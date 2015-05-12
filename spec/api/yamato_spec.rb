require 'spec_helper'

describe Tracker::Api::Yamato do
  let(:yamato) { Tracker::Api::Yamato.new no: "123412341231" }

  describe ".new" do
    subject { yamato.no }
    it { should eq "123412341231" }
  end

  describe "#execute" do
    context "データがある" do
      subject { yamato.execute }
      it { expect(subject.data).not_to be_empty }
      it { expect(subject.details).not_to be_empty }
    end
  end

  describe "#format_data" do
    subject { yamato.build_param.create_form.send_data.parse_data.format_data }
    it { expect(subject.build.status).to eq "伝票番号未登録" }
  end

  describe "#make" do
    context "オリジナルデータをもっている" do
      subject { yamato.execute.make.details[0]["origin"] }
      it { expect(subject).to_not be_empty }
    end
  end

  describe "#result" do
    context "Hash配列を返す" do
      subject { yamato.execute.make.result }
      it { should be_a Array }
      it { expect(subject[0]).to be_key "no" }
      it { expect(subject[0]).to be_key "company" }
      it { expect(subject[0]).to be_key "status" }
      it { expect(subject[0]).to be_value "123412341231" }
      it { expect(subject[0]).to be_value "yamato" }
    end
  end

end
