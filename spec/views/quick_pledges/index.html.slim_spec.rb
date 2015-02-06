require 'rails_helper'

describe "quick_pledges/index" do
  before(:each) do
    assign(:quick_pledges, [
      stub_model(QuickPledge,
        :name => "Name",
        :donation_per_click => "",
        :total_amount => "",
        :website_url => "Website Url",
        :campaign_id => 1,
        :sponsorable_id => 2,
        :sponsorable_type => "Sponsorable Type"
      ),
      stub_model(QuickPledge,
        :name => "Name",
        :donation_per_click => "",
        :total_amount => "",
        :website_url => "Website Url",
        :campaign_id => 1,
        :sponsorable_id => 2,
        :sponsorable_type => "Sponsorable Type"
      )
    ])
  end

  it "renders a list of quick_pledges" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Website Url".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Sponsorable Type".to_s, :count => 2
  end
end
