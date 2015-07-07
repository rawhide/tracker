module Tracker # :nodoc:
  module Api # :nodoc:
    class Formatter # :nodoc:
      class Status

        # 変換するコード
        class Code
          STATE = {entry: "配送中", reject: "持戻", complete: "完了", empty: "該当無し", noentry: "未登録"}

          CORPS = {
            # yamato
            "配達予定" => :entry,
            "荷受け" => :entry,
            "海外荷物受付" => :entry,
            "海外発送" => :entry,
            "調査中" => :entry,
            "配送予定" => :entry,
            "投函予定" => :entry,
            "荷物受付" => :entry,
            "依頼受付（再配達）" => :entry,
            "依頼受付（日・時間帯変更）" => :entry,
            "依頼受付（保管）" => :entry,
            "配達日・時間帯指定（保管中）" => :entry,
            "発送" => :entry,
            "作業店通過" => :entry,
            "配送店到着" => :entry,
            "配達中" => :entry,
            "配送中" => :entry,
            "持戻" => :reject,
            "持戻（ご不在）" => :reject,
            "持戻（住所不明）" => :reject,
            "持戻（受取ご辞退）" => :reject,
            "調査中（ご不在）" => :reject,
#            "持戻（休業）" => :reject,
            "配達完了" => :complete,
            "投函完了" => :complete,
            "配送完了" => :complete,
            "配達完了（宅配ボックス）" => :complete,
            "お客様引渡完了" => :complete,
            "返品" => :complete,
            "調査中（受取ご辞退）" => :complete,
            "伝票番号誤り" => :noentry,

            # sagawa
            "伝票番号未登録" => :noentry,
            "お問い合わせのデータは登録されておりません。" => :noentry,
            "お問い合わせNo.をお確かめ下さい。" => :noentry,
#            "配達中" => :entry,
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
            "配達希望受付" => :entry,
            "お届け先にお届け済み" => :complete,
            "ご不在のため持ち戻り" => :reject,
            "＊＊ お問い合わせ番号が見つかりません。お問い合わせ番号をご確認の上、お近くの取扱店にお問い合わせください。" => :noentry,
            "＊＊ お問い合わせ番号の入力桁数に誤りがあります。11桁から13桁で入力してください。" => :noentry,
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
          # ステータスがemptyになるケースでワーニングを出す
          warn str unless Code::CORPS[str]
          Code::CORPS[str] || :empty
        end
      end
    end
  end
end
