module Tracker # :nodoc:
  module Api # :nodoc:
    class Formatter # :nodoc:
      class Status

        # 変換するコード
        class Code
          STATE = {entry: "配送中", reject: "持戻", complete: "完了", empty: "該当無し", noentry: "未登録"}

          CORPS = {
            # yamato
            "発送" => :entry,
            "作業店通過" => :entry,
            "配達中" => :entry,
            "荷物受付" => :entry,
            "持戻（ご不在）" => :reject,
            "持戻" => :reject,
            "依頼受付（日・時間帯変更）" => :entry,
            "配達予定" => :entry,
            "配達完了" => :complete,
            "返品" => :complete,
            "伝票番号誤り" => :noentry,

            # sagawa
            "伝票番号未登録" => :noentry,
            "配達終了" => :complete,

            # seinou
            "受付" => :entry,
#            "発送" => :entry,
            "中継" => :entry,
            "持出" => :entry,
            "配達" => :entry,
            "配達済みです" => :complete,
#            "持戻" => :reject,
            "入力されたお問合せ番号が見当りません" => :noentry,

            # yuusei
            "引受" => :entry,
            "通過" => :entry,
            "到着" => :entry,
            "お届け先にお届け済み" => :complete,
            "ご不在のため持ち戻り" => :reject,
          }
        end

        # @param str [String] ステータス
        # @return [String] entry, reject, complete
        # @note entry: 配送中, reject: 持戻, complete: 完了
        def self.convert(str)
          obj = self.new
          obj.convert str
        end

        # @param str [String] ステータス
        # @return [String] entry, reject, complete
        def convert(str)
          Code::CORPS[str] || :empty
        end
      end
    end
  end
end
