require 'spec_helper'

describe Tracker::Api::Sagawa do
  let(:sagawa) { Tracker::Api::Sagawa.new no: "432143214321" }
  describe ".new" do
    context "initialize number" do
      subject { sagawa.no }
      it { should eq "432143214321" }
    end
  end

  describe "#execute" do
    context "return json string" do
      subject { sagawa.execute }
      it { should include '"no":"432143214321"' }
      it { should include '"status":""' }
      it { should include '"company":"sagawa"' }
      it { should include '"place":""' }
      it { should include '"description":"お問い合わせNo.をお確かめ下さい。"' }
      it { expect(JSON.parse(subject)).to be_key "status" }
    end
  end

  describe "#build_param" do
    subject { sagawa.build_param }
    it { expect(subject.data).not_to be_empty }
    it { expect(subject.data).to include ["okurijoNo", "432143214321"] }
  end

  describe "#create_form" do
    context "empty" do
      subject { sagawa.create_form }
      it { expect(subject.uri).to be_empty }
    end
    context "does not empty" do
      subject { sagawa.build_param.create_form }
      it { expect(subject.uri).not_to be_empty }
      it { expect(subject.uri).to match "okurijoNo=432143214321" }
    end
  end

  describe "#send_data" do
    #subject { sagawa.build_param.create_form.send_data }
    it {}
  end

  describe "#parse_data" do
    #subject { sagawa.build_param.create_form.send_data.parse_data }
    it {}
  end

  describe "#format_data" do
    #subject { sagawa.build_param.create_form.send_data.parse_data.format_data }
    it {}
  end
end
