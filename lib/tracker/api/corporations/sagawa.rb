require 'tracker/api/builder'
require 'tracker/api/formatter'
require 'tracker/api/implementation'
require 'nokogiri'
require 'net/http'

module Tracker
  module Api
    # 佐川
    # @see http://k2k.sagawa-exp.co.jp/p/sagawa/web/okurijoinput.jsp
    class Sagawa
      include Tracker::Api::Implementation

      def build_param
        @data = []
        @data << ["okurijoNo", @no]

        self
      end

      def create_form
        @uri = URI.encode_www_form(@data)

        self
      end

      def send_data
        #host = "http://k2k.sagawa-exp.co.jp/p/sagawa/web/okurijoinput.jsp"
        host = "http://k2k.sagawa-exp.co.jp/p/web/okurijosearch.do"
        @url = "#{host}?#{@uri}"
        @html = Net::HTTP.get(URI.parse(@url))

        self
      end

      def parse_data
        @build = Tracker::Api::Builder.new
        @doc = Nokogiri::HTML.parse(@html) do |config|
          config.noblanks
        end

        ship_date = ""
        origin_place = ""
        delivery_place = ""

        @order_no = 1
        @build.company = "sagawa"

        status = [
          "を出発致しました。",
          "から配達に出発致しました。",
          "でお預かりしております。",
        ]

        @doc.search('div[@class="table_module01 table_okurijo_detail"] > table > tbody').each do |node|
          node.search('tr').each do |tr|
            td = tr.css('td').text
            th = tr.css('th').text

            case th
            when "お問い合わせNo." #no
              @build.no = td

            when "出荷日"
              ship_date = td.strip
            when "お預かり"
              origin_place = td.strip
            when "配達"
              delivery_place = td.strip
            when "詳細表示" #description
              tr.css('td').children.each do |item|
                next unless item.text?
                @build.description = item.text
                @build.status = nil
                @build.place = nil
                @build.date = @build.description.slice(/(\d{4}年\d{2}月\d{2}日)/)
                @build.time = @build.description.slice(/(\d{2}:\d{2})/)

                # 営業所とステータスを切り出す
                desc = @build.description.sub("↑ ", "").sub("⇒/", "").slice(/\s\S+$|^\S+$/).strip

                # 営業所なし
                @build.status = desc

                # 営業所あり
                status.each do |st|
                  rp = Regexp.new(st)
                  if rp === desc
                    @build.place = $`.strip
                    # 余計な文字を削除
                    @build.status = $&.sub(/^から/, "").sub(/^を/, "").sub(/^で/, "")
                  end
                end

                @details << @build.object_to_hash
              end

              # 佐川の詳細は逆順。順番を直すついでに営業所情報を追加。
              @order_no = @details.size
              @details.each do |value|
                value["order_no"] = @order_no
                # 配達営業所
                value["place"] = delivery_place if value["status"] == "配達は終了致しました。"
                # 預かり日・営業所
                if @order_no == 1
                  value["date"] = ship_date
                  value["place"] = origin_place
                end
                @order_no -= 1
              end
            end
          end
        end

        self
      end

      # @todo self.placeに荷物の現在地を取得できるのなら取得しておく
      def insert_latest_data
        @build.company = "sagawa"
        @build.order_no = @order_no
        @details << @build.object_to_hash

        self
      end

    end
  end
end
