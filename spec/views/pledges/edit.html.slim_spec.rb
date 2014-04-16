require 'spec_helper'

describe "pledges/edit" do
  before(:each) do
    @pledge = assign(:pledge, stub_model(Pledge,
      :mission => "MyString",
      :headline => "MyString",
      :description => "MyText",
      :amount_per_click => "",
      :donation_type => "MyString",
      :total_amount => "",
      :website_url => "MyString",
      :campaign_id => 1,
      :sponsor_id => 1
    ))
  end

  it "renders the edit pledge form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", pledge_path(@pledge), "post" do
      assert_select "input#pledge_mission[name=?]", "pledge[mission]"
      assert_select "input#pledge_headline[name=?]", "pledge[headline]"
      assert_select "textarea#pledge_description[name=?]", "pledge[description]"
      assert_select "input#pledge_amount_per_click[name=?]", "pledge[amount_per_click]"
      assert_select "input#pledge_donation_type[name=?]", "pledge[donation_type]"
      assert_select "input#pledge_total_amount[name=?]", "pledge[total_amount]"
      assert_select "input#pledge_website_url[name=?]", "pledge[website_url]"
      assert_select "input#pledge_campaign_id[name=?]", "pledge[campaign_id]"
      assert_select "input#pledge_sponsor_id[name=?]", "pledge[sponsor_id]"
    end
  end
end
