require 'spec_helper'

describe "fundraiser_profiles/new" do
  before(:each) do
    assign(:fundraiser_profile, stub_model(FundraiserProfile,
      :mission => "MyText",
      :contact_title => "MyText",
      :supporter_demographic => "MyText",
      :cause => "MyString",
      :min_pledge => "",
      :min_click_donation => "MyString",
      :donations_kind => "MyString",
      :name => "MyString",
      :contact_name => "MyString",
      :website => "MyString",
      :phone => "MyString",
      :email => "MyString",
      :banner => "MyString",
      :avatar => "MyString"
    ).as_new_record)
  end

  it "renders new fundraiser_profile form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", fundraiser_profile_path, "post" do
      assert_select "textarea#fundraiser_profile_mission[name=?]", "fundraiser_profile[mission]"
      assert_select "textarea#fundraiser_profile_contact_title[name=?]", "fundraiser_profile[contact_title]"
      assert_select "textarea#fundraiser_profile_supporter_demographic[name=?]", "fundraiser_profile[supporter_demographic]"
      assert_select "input#fundraiser_profile_cause[name=?]", "fundraiser_profile[cause]"
      assert_select "input#fundraiser_profile_min_pledge[name=?]", "fundraiser_profile[min_pledge]"
      assert_select "input#fundraiser_profile_min_click_donation[name=?]", "fundraiser_profile[min_click_donation]"
      assert_select "input#fundraiser_profile_donations_kind[name=?]", "fundraiser_profile[donations_kind]"
      assert_select "input#fundraiser_profile_name[name=?]", "fundraiser_profile[name]"
      assert_select "input#fundraiser_profile_contact_name[name=?]", "fundraiser_profile[contact_name]"
      assert_select "input#fundraiser_profile_website[name=?]", "fundraiser_profile[website]"
      assert_select "input#fundraiser_profile_phone[name=?]", "fundraiser_profile[phone]"
      assert_select "input#fundraiser_profile_email[name=?]", "fundraiser_profile[email]"
      assert_select "input#fundraiser_profile_banner[name=?]", "fundraiser_profile[banner]"
      assert_select "input#fundraiser_profile_avatar[name=?]", "fundraiser_profile[avatar]"
    end
  end
end
