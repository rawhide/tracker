require 'spec_helper'
describe Tracker::Api::Formatter::Time do
  let(:format) { Tracker::Api::Formatter::Time.new }

  describe ".convert" do
    context "2015-05-12 15:57:29 +0900" do
      subject { Tracker::Api::Formatter::Time.convert("2015-05-12 15:57:29 +0900") }
      it { expect(subject).to eq "15:57:29" }
    end
  end

  describe "#convert" do
    context "17時10分" do
      subject { format.convert("17時10分") }
      it { expect(subject).to eq "17:10:00" }
    end

    context "2015-05-12 15:57:29 +0900" do
      subject { format.convert("2015-05-12 15:57:29 +0900") }
      it { expect(subject).to eq "15:57:29" }
    end

    context "20-40-01" do
      subject { format.convert("20-40-01") }
      it { expect(subject).to eq "20:40:01" }
    end

    context "nil" do
      subject { format.convert(nil) }
      it { expect(subject).to eq "00:00:00" }
    end
  end

end
