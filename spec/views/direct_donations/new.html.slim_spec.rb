require 'rails_helper'

describe "direct_donations/new" do
  before(:each) do
    assign(:direct_donation, stub_model(DirectDonation,
      :email => "MyString",
      :card_token => "MyString",
      :campaign_id => 1
    ).as_new_record)
  end

  it "renders new direct_donation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", direct_donations_path, "post" do
      assert_select "input#direct_donation_email[name=?]", "direct_donation[email]"
      assert_select "input#direct_donation_card_token[name=?]", "direct_donation[card_token]"
      assert_select "input#direct_donation_campaign_id[name=?]", "direct_donation[campaign_id]"
    end
  end
end
