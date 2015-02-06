require 'rails_helper'

describe "quick_pledges/new" do
  before(:each) do
    assign(:quick_pledge, stub_model(QuickPledge,
      :name => "MyString",
      :donation_per_click => "",
      :total_amount => "",
      :website_url => "MyString",
      :campaign_id => 1,
      :sponsorable_id => 1,
      :sponsorable_type => "MyString"
    ).as_new_record)
  end

  it "renders new quick_pledge form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", quick_pledges_path, "post" do
      assert_select "input#quick_pledge_name[name=?]", "quick_pledge[name]"
      assert_select "input#quick_pledge_donation_per_click[name=?]", "quick_pledge[donation_per_click]"
      assert_select "input#quick_pledge_total_amount[name=?]", "quick_pledge[total_amount]"
      assert_select "input#quick_pledge_website_url[name=?]", "quick_pledge[website_url]"
      assert_select "input#quick_pledge_campaign_id[name=?]", "quick_pledge[campaign_id]"
      assert_select "input#quick_pledge_sponsorable_id[name=?]", "quick_pledge[sponsorable_id]"
      assert_select "input#quick_pledge_sponsorable_type[name=?]", "quick_pledge[sponsorable_type]"
    end
  end
end
