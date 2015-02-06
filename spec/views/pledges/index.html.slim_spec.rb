require 'rails_helper'

describe "pledges/index" do
  before(:each) do
    assign(:pledges, [
      stub_model(Pledge,
        :mission => "Mission",
        :headline => "Headline",
        :description => "MyText",
        :amount_per_click => "",
        :donation_type => "Donation Type",
        :total_amount => "",
        :website_url => "Website Url",
        :campaign_id => 1,
        :sponsor_id => 2
      ),
      stub_model(Pledge,
        :mission => "Mission",
        :headline => "Headline",
        :description => "MyText",
        :amount_per_click => "",
        :donation_type => "Donation Type",
        :total_amount => "",
        :website_url => "Website Url",
        :campaign_id => 1,
        :sponsor_id => 2
      )
    ])
  end

  it "renders a list of pledges" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Mission".to_s, :count => 2
    assert_select "tr>td", :text => "Headline".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Donation Type".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Website Url".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
