require 'date'

module Tracker # :nodoc:
  module Api # :nodoc:
    class Formatter # :nodoc:
      class Date
        # @param str [String] 日付
        # @return [String] Y-m-d
        def self.convert(str)
          obj = self.new
          obj.convert str
        end

        # @param str [String] 日付
        # @return [String] Y-m-d
        def convert(str)
          str, tmp = str.to_s.split
          str = str.to_s
          str = str.gsub(/[年月\-]/, "/").gsub("日", "")
          if str.scan("/").length == 2
            date = ::Date.parse(str).to_s

          # 西暦が設定されていない場合、今日から前後半年間に存在する日付の西暦をセットする
          elsif str.scan("/").length == 1
            today = ::Date.today
            date = ::Date.parse(str)
            half_year = 365/2
            diff = date.yday - today.yday

            if diff > half_year
              date = (date - 365)
            elsif diff < -(half_year)
              date = (date + 365)
            end
          end

          str = date.to_s
        end
      end
    end
  end
end
