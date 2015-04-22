require 'spec_helper'

describe Tracker::Api::Yamato do
  let(:yamato) { Tracker::Api::Yamato.new no: "123412341231" }

  describe ".new" do
    subject { yamato.no }
    it { should eq "123412341231" }
  end

  describe "#execute" do
    context "ハッシュ配列を返す" do
      subject { yamato.execute }
      it { should be_a Array }
      it { expect(subject[0]).to be_key "no" }
      it { expect(subject[0]).to be_key "company" }
      it { expect(subject[0]).to be_key "status" }
      it { expect(subject[0]).to be_value "123412341231" }
      it { expect(subject[0]).to be_value "yamato" }
    end
  end

  describe "#format_data" do
    subject { yamato.build_param.create_form.send_data.parse_data.format_data }
    it { expect(subject.build.status).to eq "伝票番号未登録" }
  end

end
