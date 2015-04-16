require 'spec_helper'

describe Tracker::Api::Seinou do
  let(:seinou) { Tracker::Api::Seinou.new no: "1234123412" }

  describe ".new" do
    subject { seinou.no }
    it { should eq "1234123412" }
  end

  describe "#execute" do
    context "return json string" do
      subject { seinou.execute }
      it { should include '"no":"1234123412"' }
      it { should include '"status":"入力されたお問合せ番号が見当りません"' }
      it { should include '"company":"seinou"' }
      it { should include '"place":""' }
      it { expect(JSON.parse(subject)).to be_key "status" }
      it { expect(JSON.parse(subject)).to be_key "date" }
    end
  end
end
