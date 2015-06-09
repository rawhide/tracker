require 'date'

module Tracker # :nodoc:
  module Api # :nodoc:
    class Formatter # :nodoc:
      class PlannedDate
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
          str = str.gsub(/[年月]/, "/").gsub("日", "")

          # 西暦が指定されていない場合、年またぎを考慮して西暦を設定
          if str.scan("/").length == 1 && ::Date.today.month == 12 && ::Date.parse(str).month == 1
            str = (::Date.today.year + 1).to_s + "/" + str
          elsif !str.empty?
            str = ::Date.parse(str).to_s
          else
            str = "0000-00-00"
          end

          str
        end
      end
    end
  end
end
