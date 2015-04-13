require 'tracker/api/builder'
require 'tracker/api/implementation'
require 'nokogiri'

module Tracker
  module Api
    # ヤマト運輸
    # @see http://toi.kuronekoyamato.co.jp/cgi-bin/tneko
    class Yamato
      include Tracker::Api::Implementation

      def execute
        super
        "test yamato: #{self.no}"
      end
    end
  end
end
