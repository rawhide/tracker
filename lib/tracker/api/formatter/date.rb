module Tracker # :nodoc:
  module Api # :nodoc:
    class Formatter # :nodoc:
      class Date
        # @param [String] 日付
        # @return [String] m-d
        def self.convert(str)
          obj = self.new
          obj.convert str
        end

        # @param [String] 日付
        # @return [String] m-d
        def convert(str)
          str, tmp = str.to_s.split
          str = str.to_s
          str = str.gsub(/[年月]/, "-").gsub("日", "")
          str = str.gsub("/", "-")
          str = str.gsub(/\d{4}-/, "")
          str = "00-00" if str.empty?
          str
        end
      end
    end
  end
end
