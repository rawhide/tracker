module Tracker # :nodoc:
  module Api # :nodoc:
    class Formatter
      class Time
        # @param str [String] 時間
        # @return [String] H:M:S
        def self.convert(str)
          obj = self.new
          obj.convert str
        end

        # @param str [String] 時間
        # @return [String] H:M:S
        def convert(str)
          str = str.to_s
          if r = str.match(/\d+:\d+:\d+/)
            str = r[0] 
          end
          str = str.gsub(/[時分]/, ":")
          str = str.gsub("-", ":")
          str = ::Time.parse(str).strftime("%H:%M:%S") unless str.empty?
          str
        end
      end
    end
  end
end
