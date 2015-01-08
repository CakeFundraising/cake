require 'rails_helper'

describe "direct_donations/show" do
  before(:each) do
    @direct_donation = assign(:direct_donation, stub_model(DirectDonation,
      :email => "Email",
      :card_token => "Card Token",
      :campaign_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Email/)
    rendered.should match(/Card Token/)
    rendered.should match(/1/)
  end
end
