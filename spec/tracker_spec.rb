require 'spec_helper'

describe Tracker do
  describe "Base", ".execute" do
    context "run" do
      subject { Tracker::Base.execute no: "123412341231", company: "sagawa" }
      it { should include "123412341231" }
      it { should include "sagawa" }
    end

    context "does not run" do
      subject { Tracker::Base.execute no: "123hoge1234", company: "yamato" }
      it { should include "validation error" }
    end
  end
end
