require 'spec_helper'
describe Tracker::Api::Formatter do
  let(:format) { Tracker::Api::Formatter.new }
  describe "#date" do
    context "nil" do
      subject { format.date(nil) }
      it { expect(subject).to eq "00-00" }
    end
    context "5月5日" do
      subject { format.date("5月5日") }
      it { expect(subject).to eq "5-5" }
    end
    context "2015/05/01" do
      subject { format.date("2015/05/01") }
      it { expect(subject).to eq "05-01" }
    end
    context "08/01" do
      subject { format.date("08/01") }
      it { expect(subject).to eq "08-01" }
    end
    context "2015-05-12 15:58:16 +0900" do
      subject { format.date("2015-05-12 15:58:16 +0900") }
      it { expect(subject).to eq "05-12" }
    end
  end

  describe "#time" do
    context "17時10分" do
      subject { format.time("17時10分") }
      it { expect(subject).to eq "17:10:00" }
    end

    context "2015-05-12 15:57:29 +0900" do
      subject { format.time("2015-05-12 15:57:29 +0900") }
      it { expect(subject).to eq "15:57:29" }
    end

    context "20-40-01" do
      subject { format.time("20-40-01") }
      it { expect(subject).to eq "20:40:01" }
    end

    context "nil" do
      subject { format.time(nil) }
      it { expect(subject).to eq "00:00:00" }
    end
  end

  describe "#status" do
  end
end
