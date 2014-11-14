require 'spec_helper'

describe "FrSponsors" do
  describe "GET /fr_sponsors" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get fr_sponsors_path
      response.status.should be(200)
    end
  end
end
