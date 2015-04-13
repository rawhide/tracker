require 'tracker/api/const/sagawa'
require 'tracker/api/builder'
require 'tracker/api/implementation'
require 'nokogiri'

module Tracker
  module Api
    # 佐川
    # @see http://k2k.sagawa-exp.co.jp/p/sagawa/web/okurijoinput.jsp
    class Sagawa
      include Tracker::Api::Implementation

      def build_param
        @data = []
        param_jsf_tree_64
        param_jsf_state_64
        @data << ["jsf_viewid", "/web/okurijoinput.jsp"]
        (2..10).each {|i| @data << ["main:no#{i}", ""] }
        @data << ["main:toiStart", ""]
        @data << ["main:correlation", "1"]
        @data << ["main_SUBMIT", "1"]
        @data << ["main:_link_hidden_", ""]
        @data << ["main:no1", @no]

        self
      end

      def create_form
        @uri = URI.encode_www_form(@data)

        self
      end

      def send_data
        host = "http://k2k.sagawa-exp.co.jp/p/sagawa/web/okurijoinput.jsp"
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

        @doc.search('div[@class="table_module01 table_okurijo_detail"] > table > tbody').each do |node|
          node.search('tr').each do |tr|
            td = tr.css('td').text
            th = tr.css('th').text

            case th
            when "お問い合わせNo." #no
              @build.no = td
            when "配達" #status
              @build.status = td.strip
            when "詳細表示" #description
              @build.description = td
            end
          end
        end

        self
      end

      # @todo self.placeに荷物の現在地を取得できるのなら取得しておく
      def format_data
        @build.company = "sagawa"
        @build.date = Time.now
        @build.place = ""
        #@build.to_json

        self
      end

      private
      # @api private
      def param_jsf_tree_64
        @data << ["jsf_tree_64", Tracker::Api::Const::Sagawa::TREE]
      end
      
      # @api private
      def param_jsf_state_64
        @data << ["jsf_state_64", Tracker::Api::Const::Sagawa::STATE]
      end


    end
  end
end
