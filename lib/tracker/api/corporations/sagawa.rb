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

      # @todo doc.searchの精査
      # @example node.search('tr')の順序
      #   お問い合わせNo. 
      #   出荷日  
      #   お預かり  
      #   お預かり電話番号・FAX番号 
      #   配達  
      #   配達電話番号・FAX番号 
      #   荷物個数  
      #   詳細表示
      def parse_data
        @build = Tracker::Api::Builder.new
        @doc = Nokogiri::HTML.parse(@html) do |config|
          config.noblanks
        end

        @doc.search('div[@class="table_module01 table_okurijo_index scroll"] > table > tbody').each do |node|
          node.search('tr').each do |tr|
            @build.date = tr.css('td[3]').text.strip
            @build.status = tr.css('td[4]').text
          end
        end

        @doc.search('div[@class="table_module01 table_okurijo_detail"] > table > tbody').each do |node|
          node.search('tr').each do |tr|
            td = tr.css('td').text
            th = tr.css('th').text

            case th
            when "お問い合わせNo." #no
              @build.no = td
            when "配達" #place
              @build.place = td.strip
            when "詳細表示" #description
              @build.description = td
              /(\d{4}年\d{2}月\d{2}日)/ =~ td
              @build.date = $1 || @build.date
              /(\d{2}:\d{2})/ =~ td
              @build.time = $1
            end
          end
        end

        self
      end

      # @todo self.placeに荷物の現在地を取得できるのなら取得しておく
      def insert_latest_data
        @build.company = "sagawa"
        @details << @build.object_to_hash

        self
      end

    end
  end
end
