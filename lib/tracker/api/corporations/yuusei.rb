require 'tracker/api/builder'
require 'tracker/api/formatter'
require 'tracker/api/implementation'
require 'nokogiri'
require 'net/http'

module Tracker
  module Api
    # 日本郵便
    # @see https://trackings.post.japanpost.jp/services/srv/search/input
    class Yuusei
      include Tracker::Api::Implementation

      def build_param
        # ?org.apache.struts.taglib.html.TOKEN=&searchKind=S002&locale=ja&SVID=&reqCodeNo1=123312341231
        @data << ["org.apache.struts.taglib.html.TOKEN", ""]
        @data << ["searchKind", "S002"]
        @data << ["SVID", ""]
        @data << ["locale", "ja"]
        @data << ["reqCodeNo1", @no]

        self
      end

      def create_form
        @uri = URI.encode_www_form(@data)
        self
      end

      def send_data
        #host = "https://trackings.post.japanpost.jp/services/srv/search/"
        host = "https://trackings.post.japanpost.jp/services/srv/search/direct"
        @url = "#{host}?#{@uri}"
        @html = Net::HTTP.get(URI.parse(@url))

        self
      end

      # @todo ３つめのtr要素に目的のデータがあるはず
      # @example node.search('tr')[2].css('td')の順序
      #   お問い合わせ番号
      #   商品種別
      #   最新年月日
      #   最新状態
      #   最新取扱局/(郵便番号)
      #   県名等
      def parse_data
        @build = Tracker::Api::Builder.new
        @doc = Nokogiri::HTML.parse(@html) do |config|
          config.noblanks
        end
        @order_no = 1

        # table[@class="tableType01 txt_c m_b5"]
        @doc.search('table[@summary="照会結果"]').each do |node|

          if node.search('tr')[2].css('td').size == 2
            @build.no = node.search('tr')[2].css('td')[0].text
            @build.description = node.search('tr')[2].css('td')[1].text
            # お問い合せ番号が見つからないケース(配達状況詳細や履歴情報がない)を想定
            @build.status = @build.description
            @build.order_no = @order_no
          else
            node.search('tr')[2].css('td').each_with_index do |td, i|
              case i
              when 0 # お問合せ番号(追跡番号)
                @build.no = td.text
              when 1 # 商品種別
                @delivery_type = td.text
              when 2 # 最新年月日
              when 3 # 最新状態
                @build.status = td.text
              when 4 # 最新取扱局
                @build.place = td.text
              when 5 # 県名等
              end

            end
          end
        end

        # 追跡番号がないときは検索結果があるということ
        if @build.no.to_s.empty?
          no = ""
          @doc.search('table[@summary="配達状況詳細"] > tr > td').each_with_index do |node, i|
            case i
            when 0
              no = node.text.strip.gsub("-", "")
            when 1 # 商品種別
              @delivery_type = node.text
            when 4
              @planned_date = node.text
            when 5
              @planned_time = node.text
            end
          end

          # 追跡番号がとれているときは履歴を追う
          if !no.to_s.empty?
            # 配達営業所の取得
            @doc.search('table[@summary="窓口店"]').each do |node|
              node.css('tr').each do |t|
                next if t.css('td[@class="w_105"]').size == 0
                if t.css('td[@class="w_105"]')[0].text.strip == '配達'
                  @delivery_place = t.css('td[@class="w_120"]').text # 取扱局
                end
              end
            end

            @doc.search('table[@summary="履歴情報"]').each do |node|
              node.css('tr').each do |t|
                if t.css('td[@class="w_120"]').text.strip.to_s.empty?
                  # 郵便番号 の行の時は最後の行に突っ込む
                  @details.last['place_code'] = t.css('td[@class="w_105"]').text if @details.size > 0
                  next
                end

                build = Tracker::Api::Builder.new
                build.no = @no
                build.company = 'yuusei'
                date, time = t.css('td[@class="w_120"]').text.split # 状態発生日
                build.date = date
                build.time = time
                build.status = t.css('td[@class="w_150"]').text # 配送履歴（ステータス）
                build.description = t.css('td[@class="w_180"]').text # 詳細
                build.place = t.css('td[@class="w_105"]')[0].text # 取扱局
                build.planned_date = @planned_date
                build.planned_time = @planned_time
                build.delivery_type = @delivery_type
                build.delivery_place = @delivery_place
                build.order_no = @order_no
                @details << build.object_to_hash
                @order_no += 1
              end
            end
          end

        end

        self
      end

      def insert_latest_data
        @build.company = "yuusei"
        @build.date ||= ""
        @build.time ||= ""
        @build.status ||= ""
        @build.place ||= ""
        @build.place_code ||= ""
        @build.planned_date = @planned_date
        @build.planned_time = @planned_time
        @build.delivery_type = @delivery_type
        @details << @build.object_to_hash

        self
      end

    end
  end
end
