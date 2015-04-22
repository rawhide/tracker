require 'spec_helper'

describe Tracker::Api::Seinou do
  let(:seinou) { Tracker::Api::Seinou.new no: "1234123412" }

  describe ".new" do
    subject { seinou.no }
    it { should eq "1234123412" }
  end

  describe "#execute" do
    context "ハッシュ配列を返す" do
      subject { seinou.execute }
      it { should be_a Array }
      it { expect(subject[0]).to be_key "no" }
      it { expect(subject[0]).to be_key "status" }
      it { expect(subject[0]).to be_key "company" }
      it { expect(subject[0]).to be_key "place" }
      it { expect(subject[0]).to be_value "1234123412" }
      it { expect(subject[0]).to be_value "入力されたお問合せ番号が見当りません" }
      it { expect(subject[0]).to be_value "seinou" }
    end
  end
end
