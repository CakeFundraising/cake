require 'spec_helper'

describe "pledges/show" do
  before(:each) do
    @pledge = assign(:pledge, stub_model(Pledge,
      :mission => "Mission",
      :headline => "Headline",
      :description => "MyText",
      :amount_per_click => "",
      :donation_type => "Donation Type",
      :total_amount => "",
      :website_url => "Website Url",
      :campaign_id => 1,
      :sponsor_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Mission/)
    rendered.should match(/Headline/)
    rendered.should match(/MyText/)
    rendered.should match(//)
    rendered.should match(/Donation Type/)
    rendered.should match(//)
    rendered.should match(/Website Url/)
    rendered.should match(/1/)
    rendered.should match(/2/)
  end
end
