require 'spec_helper'
describe Tracker::Api::Formatter::Status do
  let(:format) { Tracker::Api::Formatter::Status.new }

  describe ".convert" do
    context "発送 => 配送中" do
      subject { Tracker::Api::Formatter::Status.convert("発送") }
      it { expect(subject).to eq "配送中" }
    end

    context "ご不在のため持ち戻り => 持戻" do
      subject { Tracker::Api::Formatter::Status.convert("ご不在のため持ち戻り") }
      it { expect(subject).to eq "持戻" }
    end

    context "配達済みです => 完了" do
      subject { Tracker::Api::Formatter::Status.convert("配達済みです") }
      it { expect(subject).to eq "完了" }
    end

    context "伝票番号未登録 => 未登録" do
      subject { Tracker::Api::Formatter::Status.convert("伝票番号未登録") }
      it { expect(subject).to eq "未登録" }
    end

    context "テスト => 該当無し" do
      subject { Tracker::Api::Formatter::Status.convert("テスト") }
      it { expect(subject).to eq "該当無し" }
    end

    context "nil => 該当無し" do
      subject { Tracker::Api::Formatter::Status.convert(nil) }
      it { expect(subject).to eq "該当無し" }
    end
  end

end
