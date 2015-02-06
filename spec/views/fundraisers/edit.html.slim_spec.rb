require 'rails_helper'

describe "fundraisers/edit" do
  before(:each) do
    @fundraiser = assign(:fundraiser, stub_model(Fundraiser,
      :banner => "MyString",
      :avatar => "MyString",
      :cause => "MyString",
      :min_pledge => 1,
      :min_click_donation => 1,
      :donations_kind => false,
      :tax_exempt => false,
      :unsolicited_pledges => false,
      :manager_name => "MyString",
      :manager_title => "MyString",
      :manager_email => "MyString",
      :manager_phone => "MyString",
      :name => "MyString",
      :mission => "MyText",
      :supporter_demographics => "MyText",
      :organization_name => "MyString",
      :phone => "MyString",
      :website => "MyString",
      :email => "MyString"
    ))
  end

  it "renders the edit fundraiser form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", fundraiser_path(@fundraiser), "post" do
      assert_select "input#fundraiser_banner[name=?]", "fundraiser[banner]"
      assert_select "input#fundraiser_avatar[name=?]", "fundraiser[avatar]"
      assert_select "input#fundraiser_cause[name=?]", "fundraiser[cause]"
      assert_select "input#fundraiser_min_pledge[name=?]", "fundraiser[min_pledge]"
      assert_select "input#fundraiser_min_click_donation[name=?]", "fundraiser[min_click_donation]"
      assert_select "input#fundraiser_donations_kind[name=?]", "fundraiser[donations_kind]"
      assert_select "input#fundraiser_tax_exempt[name=?]", "fundraiser[tax_exempt]"
      assert_select "input#fundraiser_unsolicited_pledges[name=?]", "fundraiser[unsolicited_pledges]"
      assert_select "input#fundraiser_manager_name[name=?]", "fundraiser[manager_name]"
      assert_select "input#fundraiser_manager_title[name=?]", "fundraiser[manager_title]"
      assert_select "input#fundraiser_manager_email[name=?]", "fundraiser[manager_email]"
      assert_select "input#fundraiser_manager_phone[name=?]", "fundraiser[manager_phone]"
      assert_select "input#fundraiser_name[name=?]", "fundraiser[name]"
      assert_select "textarea#fundraiser_mission[name=?]", "fundraiser[mission]"
      assert_select "textarea#fundraiser_supporter_demographics[name=?]", "fundraiser[supporter_demographics]"
      assert_select "input#fundraiser_organization_name[name=?]", "fundraiser[organization_name]"
      assert_select "input#fundraiser_phone[name=?]", "fundraiser[phone]"
      assert_select "input#fundraiser_website[name=?]", "fundraiser[website]"
      assert_select "input#fundraiser_email[name=?]", "fundraiser[email]"
    end
  end
end
