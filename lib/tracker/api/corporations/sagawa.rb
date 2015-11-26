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
        delivery_place = ""

        @order_no = 1
        @build.company = "sagawa"

        # 配送状況概要のテーブル
        # 再配達希望日時のみ取得する
        @planned_at = @doc.css('#MainList > tbody > tr:nth-child(4) > td:nth-child(2) > div').text.strip
        if @planned_at == "―"
          build.planned_date = nil
          build.planned_time = nil
        else
          # TODO: inoue 再配達のデータが入り次第、以下を修正する
          #build.planned_date = @planned_date
          #build.planned_time = @planned_time
        end

        # 1つめの配送状況詳細のテーブル
        @doc.search('.table_okurijo_detail').each do |node|
          node.search('tr').each do |tr|
            td = tr.css('td').text
            th = tr.css('th').text

            case th
            when "お問い合せ送り状NO"
              @build.no = td
            when "出荷日"
              ship_date = td.strip
            when "配達営業所"
              delivery_place = td.strip.slice(/.*営業所/)
            when "詳細表示"
              # TODO: inoue 番号解析できたら振り分ける
            end
          end
        end

        # 2つめの配送状況詳細のテーブル
        @doc.search('.table_okurijo_detail2').each do |node|
          node.css('tr').each_with_index do |tr, i|

            build = Tracker::Api::Builder.new
            build.no = @no
            tr.css('td').each_with_index do |n, j|
              raw_data = n.text.strip
              case j
              when 0 # 荷物状況
                build.status = raw_data.sub("↑", "").sub("⇒", "").sub("↓", "")
              when 1 # 日時
                raw_data.match(/\s/)
                build.date = $`
                build.time = $'
              when 2 # 担当営業所
                build.place = raw_data
              end
            end
            build.company = "sagawa"
            build.order_no = i
            @details << build.object_to_hash
          end
        end

        self
      end

      def insert_latest_data
        @build.company = "sagawa"
        @build.order_no = @order_no
        @details << @build.object_to_hash

        self
      end

    end
  end
end
