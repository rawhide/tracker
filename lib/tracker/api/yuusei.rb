require 'tracker/api/builder'
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

        # table[@class="tableType01 txt_c m_b5"]
        @doc.search('table[@summary="照会結果"]').each do |node|

          if node.search('tr')[2].css('td').size == 2
            @build.no = node.search('tr')[2].css('td')[0].text
            @build.description = node.search('tr')[2].css('td')[1].text
          else
            node.search('tr')[2].css('td').each_with_index do |td, i|
              case i
              when 0 # お問合せ番号(追跡番号)
                @build.no = td.text
              when 1 # 商品種別
              when 2 # 生年月日
              when 3 # 最新状態
                @build.status = td.text
              when 4 # 最新取扱局
                @build.place = td.text
              when 5 # 県名等
              end

            end
          end
        end

        self
      end

      def format_data
        @build.company = "yuusei"
        @build.date = Time.now
        @build.status ||= ""
        @build.place ||= ""

        @details << @build.object_to_hash

        self
      end
    end
  end
end
