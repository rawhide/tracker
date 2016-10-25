require 'tracker/api/builder'
require 'tracker/api/formatter'
require 'tracker/api/implementation'
require 'nokogiri'
require 'net/http'

module Tracker
  module Api
    # デリバリープロバイダー
    # @see http://track-a.tmg-group.jp/cts/TmgCargoSearchAction.do?method_id=INIT
    # Cookieが必要なことや一回検索結果ページを経由して詳細画面に遷移するため他の業者と実装が微妙に変わる
    class DeliveryProvider
      include Tracker::Api::Implementation

      def build_param
        @data = []
        @data << ["method_id", "POPUPSEA"]
        @data << ["inputData[0].inq_no", @no]

        self
      end

      def create_form
        @uri = URI.encode_www_form(@data)

        self
      end

      def send_data
        # cookieがないと情報取得できない模様
        host = "track-a.tmg-group.jp"
        http = Net::HTTP.new(host)
        path = "/cts/TmgCargoSearchAction.do"

        # cookie取得のための通信
        res = http.get("#{path}?method_id=INIT")
        @cookie = res.get_fields("set-cookie").first.match(/(JSESSIONID=.*);/)[1]

        # 検索のための通信
        res = http.get("#{path}?#{@uri}", {"Cookie" => @cookie})

        # 検索結果画面
        @url = "http://#{host}#{path}?#{@uri}"
        @html = res.body

        self
      end

      def parse_data
        @build = Tracker::Api::Builder.new
        @doc = Nokogiri::HTML.parse(@html) do |config|
          config.noblanks
        end

        @doc.search('table[@id="list"]').each do |node|
          node.css('tr').each_with_index do |tr, i|
            next if i != 1
            @build.no = tr.search('td[@class="inq_list_input"]').text.strip
            @build.status = tr.search('td[@class="inq_list_status"]').text.strip
            unless @build.status == ""
              # 詳細はformボタンを押して別ページに表示される
              detail_info = tr.search('td[@class="inq_list_dtl"]').first
              params =  detail_info.children.search("input")[0].attributes["onclick"].value.match(/(\(.*\))/)[1].split(',')
              doc = Nokogiri::HTML.parse(detail_html(params: params)) do |config|
                config.noblanks
              end

              doc.search('table[@class="dtl2"]').each do |node|
                node.css('tr').each_with_index do |tr, i|

                  build = Tracker::Api::Builder.new
                  build.no = @no

                  tr.css('td').each_with_index do |n, j|
                    case j
                      when 0 #日付
                        build.date = n.text
                      when 1 #商品所在地
                        build.place = n.text
                      when 2 #状態
                        build.status = n.text
                    end
                  end
                  build.company = "delivery_provider"
                  build.order_no = i
                  @details << build.object_to_hash unless i == 0
                end
              end
            else
              # 検索結果がないときの文言にお問い合わせ番号がまじるため、"未登録"に書き換える
              @build.status = "未登録"
              if @build.no == ""
                @build.no = @no
              end
            end
          end
        end

        self
      end

      def insert_latest_data
        @build.company = "delivery_provider"
        @details << @build.object_to_hash
        self
      end

      private
        def detail_html(params:)
          # formで使っているパラメーターを切り出す
          tmp_mani_num = params[1].gsub(/\'/, '')
          tmp_trk_id = params[2].gsub(/\'/, '')
          tmp_item_num = params[3].gsub(/\'/, '')
          tmp_cust_ord_num = params[4].gsub(/(\'|\))/, '')

          data = []
          data << ["method_id", "DTL_SHOW"]
          data << ["tmp_mani_num", tmp_mani_num]
          data << ["tmp_trk_id", tmp_trk_id]
          data << ["tmp_item_num", tmp_item_num]
          data << ["tmp_cust_ord_num", tmp_cust_ord_num]

          host = "track-a.tmg-group.jp"
          http = Net::HTTP.new(host)
          path = "/cts/TmgCargoSearchAction.do"

          res = http.get("#{path}?#{URI.encode_www_form(data)}", {"Cookie" => @cookie})

          res.body
        end
    end
  end
end
