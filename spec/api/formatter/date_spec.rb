require 'spec_helper'
describe Tracker::Api::Formatter::Date do
  let(:format) { Tracker::Api::Formatter::Date.new }

  describe ".convert" do
    context "2015/05/01" do
      subject { Tracker::Api::Formatter::Date.convert("2015/05/01") }
      it { expect(subject).to eq "05-01" }
    end
  end

  describe "#convert" do
    context "nil" do
      subject { format.convert(nil) }
      it { expect(subject).to eq "00-00" }
    end
    context "5月5日" do
      subject { format.convert("5月5日") }
      it { expect(subject).to eq "5-5" }
    end
    context "2015/05/01" do
      subject { format.convert("2015/05/01") }
      it { expect(subject).to eq "05-01" }
    end
    context "08/01" do
      subject { format.convert("08/01") }
      it { expect(subject).to eq "08-01" }
    end
    context "2015-05-12 15:58:16 +0900" do
      subject { format.convert("2015-05-12 15:58:16 +0900") }
      it { expect(subject).to eq "05-12" }
    end
  end

end
