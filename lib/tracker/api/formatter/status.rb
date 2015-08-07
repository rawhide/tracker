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
        def self.convert(str, com)
          obj = self.new
          obj.convert(str, com)
        end

        # @param str [String] ステータス
        # @return [String] entry, reject, complete
        def convert(str, com)
          # ステータスがemptyになるケースでワーニングを出す
          warn str unless Code::CORPS[com][str]
          Code::CORPS[com][str] || :empty
        end
      end
    end
  end
end
