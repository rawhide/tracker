require 'spec_helper'

describe Tracker::Api::Yuusei do
  let(:yuusei) { Tracker::Api::Yuusei.new no: "123412341231" }

  describe ".new" do
    context "initialize number" do
      subject { yuusei.no }
      it { should eq "123412341231" }
    end
  end

  describe "#execute" do
    context "return json string" do
      subject { yuusei.execute }
      it { should include '"no":"123412341231"' }
      it { should include '"status":""' }
      it { should include '"place":""' }
      it { should include '"company":"yuusei"' }
      it { should match /お問い合わせ番号が見つかりません/ }
      it { expect(JSON.parse(subject)).to be_key "status" }
      it { expect(JSON.parse(subject)).to be_key "date" }
    end
  end

  describe "#build_param" do
    subject { yuusei.build_param }
    it { expect(subject.data).to include ["reqCodeNo1", "123412341231"] }
  end

  describe "#create_form" do
    subject { yuusei.build_param.create_form }
    it { expect(subject.uri).not_to be_empty }
    it { expect(subject.uri).to match "&reqCodeNo1=123412341231" }
  end

end
