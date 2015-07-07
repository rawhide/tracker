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

        @build.company = "sagawa"
        status = ["お荷物をお預かり致しました。",
                  "を出発致しました。",
                  "から配達に出発致しました。",
                  "でお預かりしております。",
                  "配達は終了致しました。",
                  "ご不在でしたので、お預かりしております。",
                  "お問い合わせNo.をお確かめ下さい。"]

        @doc.search('div[@class="table_module01 table_okurijo_detail"] > table > tbody').each do |node|
          node.search('tr').each do |tr|
            td = tr.css('td').text
            th = tr.css('th').text
            
            case th
            when "お問い合わせNo." #no
              @build.no = td

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
                status.each do |st|
                  rp = Regexp.new(st)
                  if rp === desc
                    @build.status = $&
                    @build.place = $`.strip unless $`.empty?
                  end
                end

                @details << @build.object_to_hash
              end


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
