module Tracker # :nodoc:
  module Api # :nodoc:
    class Validation
      # @param no [String] 追跡番号
      def initialize(no: nil)
        @no = no
        @errors = []
      end

      # エラーメッセージ
      # @return [Array]
      def errors
        @errors
      end

      # バリデーションチェック
      # @return [Boolean]
      def valid?
        length?
        numeric?
        checkdigit?
        @errors.empty?
      end

      # 追跡番号の桁数チェック
      # @return [Boolean]
      def length?
        return true if @no.length == 12
        @errors << "number of digits does not match." 
        false
      end

      # 追跡番号の数字チェック
      # @return [Boolean]
      def numeric?
        return true if @no.match(/^\d+$/)
        @errors << "not a number." 
        false
      end

      # チェックデジット
      # @return [Boolean]
      def checkdigit?
        last = @no[-1].to_i
        return true if (@no[0..10].to_i % 7) == last
        @errors << "checkdigit does not match." 
        false
      end
    end

  end
end
