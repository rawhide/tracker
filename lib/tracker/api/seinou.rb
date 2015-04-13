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

      def execute
        super
        "test seinou: #{self.no}"
      end
    end
  end
end
