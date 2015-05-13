require 'spec_helper'

describe Tracker::Api::Seinou do
  let(:seinou) { Tracker::Api::Seinou.new no: "1234123412" }

  describe ".new" do
    subject { seinou.no }
    it { should eq "1234123412" }
  end

  describe "#execute" do
    context "データがある" do
      subject { seinou.execute }
      it { expect(subject.data).not_to be_empty }
      it { expect(subject.details).not_to be_empty }
    end
  end

  describe "#make" do
    context "オリジナルデータをもっている" do
      subject { seinou.execute.make.details[0]["origin"] }
      it { expect(subject).not_to be_empty }
    end
  end

  describe "#result" do
    context "Hash配列をかえす" do
      subject { seinou.execute.make.result }
      it { should be_a Array }
      it { expect(subject[0]).to be_key "no" }
      it { expect(subject[0]).to be_key "status" }
      it { expect(subject[0]).to be_key "company" }
      it { expect(subject[0]).to be_key "place" }
      it { expect(subject[0]).to be_value "1234123412" }
      #"入力されたお問合せ番号が見当りません"
      it { expect(subject[0]).to be_value "該当無し" }
      it { expect(subject[0]).to be_value "seinou" }
    end
  end
end
