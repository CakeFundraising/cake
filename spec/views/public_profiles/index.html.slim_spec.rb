require 'spec_helper'

describe "public_profiles/index" do
  before(:each) do
    assign(:public_profiles, [
      stub_model(PublicProfile,
        :head_line => "MyText",
        :profile_message => "MyText",
        :demographic_description => "MyText",
        :cause => "Cause",
        :min_pledge => "",
        :min_click_donation => "Min Click Donation",
        :donations_kind => "Donations Kind",
        :name => "Name",
        :contact_name => "Contact Name",
        :website => "Website",
        :phone => "Phone",
        :email => "Email",
        :banner => "Banner",
        :avatar => "Avatar"
      ),
      stub_model(PublicProfile,
        :head_line => "MyText",
        :profile_message => "MyText",
        :demographic_description => "MyText",
        :cause => "Cause",
        :min_pledge => "",
        :min_click_donation => "Min Click Donation",
        :donations_kind => "Donations Kind",
        :name => "Name",
        :contact_name => "Contact Name",
        :website => "Website",
        :phone => "Phone",
        :email => "Email",
        :banner => "Banner",
        :avatar => "Avatar"
      )
    ])
  end

  it "renders a list of public_profiles" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Cause".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Min Click Donation".to_s, :count => 2
    assert_select "tr>td", :text => "Donations Kind".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Contact Name".to_s, :count => 2
    assert_select "tr>td", :text => "Website".to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Banner".to_s, :count => 2
    assert_select "tr>td", :text => "Avatar".to_s, :count => 2
  end
end
