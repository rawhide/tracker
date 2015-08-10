require 'yaml'

module Tracker # :nodoc:
  module Api # :nodoc:
    class Formatter # :nodoc:
      class Status

        # 変換するコード
        class Code
          STATE = {entry: "配送中", reject: "持戻", complete: "完了", empty: "該当無し", noentry: "未登録"}
          CORPS = YAML::load_file(File.join(__dir__, 'status.yml'))
        end

        # @param str [String] ステータス
        # @return [String] entry, reject, complete
        # @note entry: 配送中, reject: 持戻, complete: 完了
        def self.convert(str, company)
          obj = self.new
          obj.convert(str, company)
        end

        # @param str [String] ステータス
        # @return [String] entry, reject, complete
        def convert(str, company)
          # ステータスがemptyになるケースでワーニングを出す
          warn str unless Code::CORPS[company][str]
          Code::CORPS[company][str] || :empty
        end
      end
    end
  end
end
