require 'tracker/api/builder'
require 'tracker/api/implementation'
require 'nokogiri'

module Tracker
  module Api
    # ヤマト運輸
    # @see http://toi.kuronekoyamato.co.jp/cgi-bin/tneko
    class Yamato
      include Tracker::Api::Implementation

      def build_param
        @data = {}
        @data["number00"] = 1
        @data["number01"] = @no

        self
      end

      def create_form
        self
      end

      def send_data
        host = "http://toi.kuronekoyamato.co.jp/cgi-bin/tneko"
        uri = URI.parse(host)
        res = Net::HTTP.start(uri.host, uri.port) do |http|
          req = Net::HTTP::Post.new uri.path
          req.set_form_data @data
          http.request(req)
        end
        @html = res.body

        self
      end

      def parse_data
        @build = Tracker::Api::Builder.new
        @doc = Nokogiri::HTML.parse(@html) do |config|
          config.noblanks
        end

        @doc.search('table[@class="saisin"]').each do |node|
          node.search('tr').each_with_index do |tr, i|
            case i
            when 0
              # img X件目 伝票番号
              @build.no = @no
            when 1
              # br br status
              @build.status = tr.css('td').text
            when 2
              # desc1
              @build.description = tr.css('td').text
            when 3
              # desc2
              #@build.description = tr.css('td').text
            end
          end
        end

        self
      end

      def format_data
        @build.company = "yamato"
        @build.place = "" #荷物の場所

        self
      end
    end
  end
end
