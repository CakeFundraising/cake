require 'spec_helper'

describe "direct_donations/edit" do
  before(:each) do
    @direct_donation = assign(:direct_donation, stub_model(DirectDonation,
      :email => "MyString",
      :card_token => "MyString",
      :campaign_id => 1
    ))
  end

  it "renders the edit direct_donation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", direct_donation_path(@direct_donation), "post" do
      assert_select "input#direct_donation_email[name=?]", "direct_donation[email]"
      assert_select "input#direct_donation_card_token[name=?]", "direct_donation[card_token]"
      assert_select "input#direct_donation_campaign_id[name=?]", "direct_donation[campaign_id]"
    end
  end
end
