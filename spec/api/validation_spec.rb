require 'spec_helper'

describe Tracker::Api::Validation do
  let(:valid) { Tracker::Api::Validation.new no: "123412341231" }
  let(:length_10) { Tracker::Api::Validation.new no: "4321432121" }
  let(:no_valid) { Tracker::Api::Validation.new no: "1foo" }
  let(:no_digit) { Tracker::Api::Validation.new no: "123412341234" }
  let(:no_length) { Tracker::Api::Validation.new no: "11234123412" }
  let(:no_numeric) { Tracker::Api::Validation.new no: "1234hoge1234" }

  describe "#length?" do
    context "match" do
      subject { valid.length? }
      it { should be_truthy }
    end

    context "does not match" do
      subject { no_length.length? }
      it { should be_falsy }
    end

    context "10 length match" do
      subject { length_10.length? }
      it { should be_truthy }
    end
  end

  describe "#numeric?" do
    context "match" do
      subject { valid.numeric? }
      it { should be_truthy }
    end

    context "does not match" do
      subject { no_numeric.numeric? }
      it { should be_falsy }
    end
  end

  describe "#checkdigit?" do
    context "match" do
      subject { valid.checkdigit? }
      it { should be_truthy }
    end

    context "does not match" do
      subject { no_digit.checkdigit? }
      it { should be_falsy }
    end

    context "10 length through" do
      subject { length_10.checkdigit? }
      it { should be_truthy }
    end
  end

  describe "#valid?" do
    context "errors" do
      before { no_valid.valid? }
      it { expect(no_valid.errors).not_to be_empty }
    end
  end
end
