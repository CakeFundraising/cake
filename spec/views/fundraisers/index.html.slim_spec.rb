require 'spec_helper'

describe "fundraisers/index" do
  before(:each) do
    assign(:fundraisers, [
      stub_model(Fundraiser,
        :banner => "Banner",
        :avatar => "Avatar",
        :cause => "Cause",
        :min_pledge => 1,
        :min_click_donation => 2,
        :donations_kind => false,
        :tax_exempt => false,
        :unsolicited_pledges => false,
        :manager_name => "Manager Name",
        :manager_title => "Manager Title",
        :manager_email => "Manager Email",
        :manager_phone => "Manager Phone",
        :name => "Name",
        :mission => "MyText",
        :supporter_demographics => "MyText",
        :organization_name => "Organization Name",
        :phone => "Phone",
        :website => "Website",
        :email => "Email"
      ),
      stub_model(Fundraiser,
        :banner => "Banner",
        :avatar => "Avatar",
        :cause => "Cause",
        :min_pledge => 1,
        :min_click_donation => 2,
        :donations_kind => false,
        :tax_exempt => false,
        :unsolicited_pledges => false,
        :manager_name => "Manager Name",
        :manager_title => "Manager Title",
        :manager_email => "Manager Email",
        :manager_phone => "Manager Phone",
        :name => "Name",
        :mission => "MyText",
        :supporter_demographics => "MyText",
        :organization_name => "Organization Name",
        :phone => "Phone",
        :website => "Website",
        :email => "Email"
      )
    ])
  end

  it "renders a list of fundraisers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Banner".to_s, :count => 2
    assert_select "tr>td", :text => "Avatar".to_s, :count => 2
    assert_select "tr>td", :text => "Cause".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Manager Name".to_s, :count => 2
    assert_select "tr>td", :text => "Manager Title".to_s, :count => 2
    assert_select "tr>td", :text => "Manager Email".to_s, :count => 2
    assert_select "tr>td", :text => "Manager Phone".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Organization Name".to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    assert_select "tr>td", :text => "Website".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
  end
end
