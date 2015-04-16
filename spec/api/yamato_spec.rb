require 'spec_helper'

describe Tracker::Api::Yamato do
  let(:yamato) { Tracker::Api::Yamato.new no: "123412341231" }

  describe ".new" do
    subject { yamato.no }
    it { should eq "123412341231" }
  end

  describe "#execute" do
    context "return json text" do
      subject { yamato.execute }
      it { should include '"no":"123412341231"' }
      it { should include '"status":"伝票番号未登録"' }
      it { should include '"company":"yamato"' }
      it { should include '"place":""' }
      it { expect(JSON.parse(subject)).to be_key "status" }
    end
  end

  describe "#format_data" do
    subject { yamato.build_param.create_form.send_data.parse_data.format_data }
    it { expect(subject.build.status).to eq "伝票番号未登録" }
  end

end
