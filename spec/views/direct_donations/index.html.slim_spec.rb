require 'spec_helper'

describe "direct_donations/index" do
  before(:each) do
    assign(:direct_donations, [
      stub_model(DirectDonation,
        :email => "Email",
        :card_token => "Card Token",
        :campaign_id => 1
      ),
      stub_model(DirectDonation,
        :email => "Email",
        :card_token => "Card Token",
        :campaign_id => 1
      )
    ])
  end

  it "renders a list of direct_donations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Card Token".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
