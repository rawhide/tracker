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
    context "ハッシュ配列を返す" do
      subject { sagawa.execute }
      it { should be_a Array }
      it { expect(subject[0]).to be_key "no" }
      it { expect(subject[0]).to be_key "company" }
      it { expect(subject[0]).to be_key "status" }
      it { expect(subject[0]).to be_key "place" }
      it { expect(subject[0]).to be_value "432143214321" }
      it { expect(subject[0]).to be_value "sagawa" }
      it { expect(subject[0]).to be_value "お問い合わせNo.をお確かめ下さい。" }
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

end
