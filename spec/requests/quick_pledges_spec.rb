require 'spec_helper'

describe "QuickPledges" do
  describe "GET /quick_pledges" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get quick_pledges_path
      response.status.should be(200)
    end
  end
end
