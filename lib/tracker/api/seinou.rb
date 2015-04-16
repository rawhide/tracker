require 'tracker/api/builder'
require 'tracker/api/implementation'
require 'nokogiri'

module Tracker
  module Api
    # 西濃
    # @see https://track.seino.co.jp/kamotsu/GempyoNoShokai.do
    # @note 西濃は追跡番号が10桁
    class Seinou
      include Tracker::Api::Implementation

      def build_param
        @data = []
        @data << ["GNPNO1", @no]

        self
      end

      def create_form
        @uri = URI.encode_www_form(@data)
        self
      end

      def send_data
        host = "https://track.seino.co.jp/cgi-bin/gnpquery.pgm"
        @url = "#{host}?#{@uri}"
        @html = Net::HTTP.get(URI.parse(@url))

        self
      end

      def parse_data
        @build = Tracker::Api::Builder.new
        @doc = Nokogiri::HTML.parse(@html, nil, "CP932") do |config|
          config.noblanks
        end

        @doc.search('table[@summary="お届け状況確認 検索"]').each do |node|
          node.css('tr').each_with_index do |tr, i|
            next if i != 1
            @build.no = tr.search('td[@class="col3"]').text.strip
            @build.status = tr.search('td[@class="col4"]').text.strip
          end
        end

        self
      end

      def format_data
        @build.company = "seinou"
        @build.date = Time.now
        @build.place = ""

        self
      end
    end
  end
end
