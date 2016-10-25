require 'spec_helper'

describe Tracker::Api::DeliveryProvider do
  let(:delivery_provider) { Tracker::Api::DeliveryProvider.new no: "123412341231" }

  describe ".new" do
    subject { delivery_provider.no }
    it { should eq "123412341231" }
  end

  describe "#execute" do
    context "データがある" do
      subject { delivery_provider.execute }
      it { expect(subject.data).not_to be_empty }
      it { expect(subject.details).not_to be_empty }
    end
  end

  describe "#make" do
    context "オリジナルデータをもっている" do
      subject { delivery_provider.execute.make.details[0]["origin"] }
      it { expect(subject).to_not be_empty }
    end
  end

  describe "#result" do
    context "Hash配列を返す" do
      subject { delivery_provider.execute.make.result }
      it { should be_a Array }
      it { expect(subject[0]).to be_key "no" }
      it { expect(subject[0]).to be_key "company" }
      it { expect(subject[0]).to be_key "status" }
      it { expect(subject[0]).to be_value "123412341231" }
      it { expect(subject[0]).to be_value "delivery_provider" }
    end
  end

end
