require 'spec_helper'

describe "quick_pledges/show" do
  before(:each) do
    @quick_pledge = assign(:quick_pledge, stub_model(QuickPledge,
      :name => "Name",
      :donation_per_click => "",
      :total_amount => "",
      :website_url => "Website Url",
      :campaign_id => 1,
      :sponsorable_id => 2,
      :sponsorable_type => "Sponsorable Type"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(/Website Url/)
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/Sponsorable Type/)
  end
end
