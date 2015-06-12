require 'tracker/api/formatter/date'
require 'tracker/api/formatter/time'
require 'tracker/api/formatter/status'
require 'tracker/api/formatter/planned_date'

module Tracker # :nodoc:
  module Api # :nodoc:
    # フォーマットを揃える
    class Formatter
      # @param str [String] 日付
      # @return [String] m-d
      def date(str)
        Tracker::Api::Formatter::Date.convert str
      end

      # @param str [String] 時間
      # @return [String] H:M:S
      def time(str)
        Tracker::Api::Formatter::Time.convert str
      end

      # @param str [String] ステータス
      # @return [String] entry, reject, complete
      def status(str)
        Tracker::Api::Formatter::Status.convert str
      end

      # @param str [String] 日付
      # @return [String] Y-m-d
      def planned_date(str)
        Tracker::Api::Formatter::PlannedDate.convert str
      end

    end
  end
end
