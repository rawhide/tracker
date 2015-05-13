require 'tracker/api/builder'
require 'tracker/api/formatter'
require 'tracker/api/implementation'
require 'nokogiri'
require 'net/http'

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

      # @todo build.date = "#{date}日" これなんとかならないのか
      def parse_data
        state = ["受 付", "発 送", "中 継", "到 着", "持 出", "配 達"]
        @build = Tracker::Api::Builder.new
        @doc = Nokogiri::HTML.parse(@html, nil, "CP932") do |config|
          config.noblanks
        end

        @doc.search('table[@summary="お届け状況確認 検索"]').each do |node|
          node.css('tr').each_with_index do |tr, i|
            next if i != 1
            @build.date = tr.search('td[@class="col2"]').text.strip
            @build.no = tr.search('td[@class="col3"]').text.strip
            @build.status = tr.search('td[@class="col4"]').text.strip.gsub(/[\u00A0]/, "").gsub(/\s/, "")
          end
        end

        if !@build.date.empty?
          @doc.search('table[@summary="お届物詳細"]').each do |node|
            node.css('tr').each do |tr|
              col1 = tr.css('td[@class="col1"]').text.strip.gsub(/[\u00A0]/, "").gsub(/\s/, "")
              col2 = tr.css('td[@class="col2"]').text.strip.gsub(/[\u00A0]/, "")
              col3 = tr.css('td[@class="col3"]').text.strip.gsub(/[\u00A0]/, "")

              if !col1.empty? #&& state.include?(col1)
                build = Tracker::Api::Builder.new
                build.no = @no
                build.company = "seinou"
                build.status = col1
                build.place = col2
                date, time = col3.split("日")
                build.date = "#{Date.today.month}月#{date}日"
                build.time = time
                build.description = ""
                @details << build.object_to_hash
              end

            end
          end
        end

        self
      end

      def format_data
        @build.company = "seinou"
        @build.date ||= Date.today.to_s
        @build.time ||= Time.now.to_s
        @build.place = ""
        @details << @build.object_to_hash

        self
      end

    end
  end
end
