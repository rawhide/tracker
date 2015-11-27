module Tracker # :nodoc:
  module Api # :nodoc:
    module Implementation

      # @!attribute no
      #   @return [String] 追跡番号
      # @!attribute build
      #   @return [Tracker::Api::Builder]  解析結果
      # @!attribute details
      #   @return [Array] 明細行
      attr_accessor :no, :build, :details

      # @!attribute [r] data
      #   @return [Array] 送信パラメータ
      # @!attribute [r] uri
      #   @return [String] uriパラメータ
      # @!attribute [r] url
      #   @return [String] 送信URL
      # @!attribute [r] html
      #   @return [String] レスポンスHTML
      # @!attribute [r] doc
      #   @return [Nokogiri::HTML::Document] 解析用
      #
      attr :data, :uri, :url, :html, :doc

      # @param no [String] 追跡番号
      def initialize(no: nil)
        @no = no
        @data = []
        @uri = ""
        @url = ""
        @html = nil
        @doc = nil
        @build = nil
        @details = []
      end

      # 追跡番号から荷物の状態を検索する
      # @return [Object] self
      def execute
        build_param
        create_form
        send_data
        parse_data
        insert_latest_data if @details.empty?
        #@build.to_json

        self
      end

      # 結果を返す
      # @return [Array] in objects Tracker::Api::Builder
      # @example
      #   current:
      #   [[{"no"=>"1234123400", "status"=>"入力されたお問合せ番号が見当りません", "date"=>"", "time"=>nil, "place"=>"", "company"=>"seinou", "description"=>nil, "origin"=>nil}]]
      #   old:
      #   [
      #   #<Tracker::Api::Builder:0x007fbfd15cfd58>,
      #   #<Tracker::Api::Builder:0x007fbfd0afa450>,
      #   #<Tracker::Api::Builder:0x007fbfd148e958>
      #   ]
      #   old:
      #    {"no":"123412341231","status":"","date":"2015-04-13 13:49:02 +0900","company":"sagawa","description":"お問い合わせのデータは登録されておりません。","origin":null}
      # 

      def result
        @details
      end

      # データを統一のフォーマットに変換する
      # @return [Object] self
      def make
        format = Tracker::Api::Formatter.new
        details = []
        @details.each do |hash|
          build = Tracker::Api::Builder.new hash
          build.copy
          build.status = format.status(build.status, build.company)
          build.date = format.date(build.date)
          build.time = format.time(build.time)
          build.place ||= ""
          build.place_code ||= ""
          build.delivery_place ||= ""
          build.delivery_type ||= ""
          build.planned_date = format.date(build.planned_date)
          build.planned_time ||= ""
          details << build.object_to_hash
        end
        @details = details

        self
      end

      # 検索用のデータをセットする
      # @abstract override {#build_param} to implement
      # @return [Object] self
      # @raise NotImplementedError
      def build_param
        raise NotImplementedError, "#build_param"
      end

      # 検索用データをWEB送信用に作成する
      # @abstract override {#create_form} to implement
      # @return [Object] self
      # @raise NotImplementedError
      def create_form
        raise NotImplementedError, "#create_form"
      end

      # データを送信する
      # @abstract override {#send_data} to implement
      # @return [Object] self
      # @raise NotImplementedError
      def send_data
        raise NotImplementedError, "#send_data"
      end

      # 送信した結果を取得して解析する
      # @abstract override {#parse_data} to implement
      # @return [Object] self
      # @raise NotImplementedError
      def parse_data
        raise NotImplementedError, "#parse_data"
      end

      # 解析結果を整形する
      # @abstract override {#insert_latest_data} to implement
      # @return [Object] self
      # @raise NotImplementedError
      def insert_latest_data
        raise NotImplementedError, "#insert_latest_data"
      end
    end
  end
end
