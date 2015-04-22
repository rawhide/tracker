require 'spec_helper'

describe Tracker::Api::Builder do
  let(:build) { Tracker::Api::Builder.new no: "123412341234", status: "entry", company: "yamato" }
  describe "#object_to_hash" do
    subject { build.object_to_hash }
    it { should be_a Hash }
    it { should be_key "status" }
    it { should be_key "no" }
  end
  describe "#object_to_json" do
    subject { build.object_to_json }
    it { should be_a String }
    it { should include '"status":"entry"' }
    it { should include '"no":"123412341234"' }
  end
end
