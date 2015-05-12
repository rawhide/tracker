module Tracker # :nodoc:
  module Api # :nodoc:
    # フォーマットを揃える
    class Formatter
      # @param [String] 日付
      # @return [String] m-d
      def date(str)
        str, tmp = str.to_s.split
        str = str.to_s
        str = str.gsub(/[年月]/, "-").gsub("日", "")
        str = str.gsub("/", "-")
        str = str.gsub(/\d{4}-/, "")
        str = "00-00" if str.empty?
        str
      end

      # @param [String] 時間
      # @return [String] H:M:S
      def time(str)
        str = str.to_s
        if r = str.match(/\d+:\d+:\d+/)
          str = r[0] 
        end
        str = str.gsub(/[時分]/, ":")
        str = str.gsub("-", ":")
        str = "00:00:00" if str.empty?
        str = Time.parse(str).strftime("%H:%M:%S")
        str
      end

      # @param [String] ステータス
      # @return [String] entry, reject, complete
      def status(str)
        str
      end
    end
  end
end
