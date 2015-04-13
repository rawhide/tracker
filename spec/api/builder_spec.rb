require 'spec_helper'

describe Tracker::Api::Builder do
  describe "#to_json" do
    let(:build) { Tracker::Api::Builder.new no: 123412341234, status: "entry", company: "yamato" }
    subject { build.to_json }
    it { should be_a String }
    it { should include '"status":"entry"' }
    it { should include '"no":"123412341234"' }
  end
end
