require 'spec_helper'

describe Tracker do
  describe "Base", ".execute" do
    context "run" do
      subject { Tracker::Base.execute(no: "123412341231", company: "sagawa")[0].first }
      it { should be_value "123412341231" }
      it { should be_value "sagawa" }
    end

    context "does not run" do
      subject { Tracker::Base.execute no: "123hoge1234", company: "yamato", validation: true }
      it { should include "validation error" }
    end

    context "array run" do
      subject { Tracker::Base.execute no: "123412341231" }
      it { should be_a Array }
      it { expect(subject[0]).to be_a Array }
      it { expect(subject.count).to eq 3 }
    end
  end
end
