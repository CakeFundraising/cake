require 'spec_helper'

describe "public_profiles/edit" do
  before(:each) do
    @public_profile = assign(:public_profile, stub_model(PublicProfile,
      :head_line => "MyText",
      :profile_message => "MyText",
      :demographic_description => "MyText",
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
    ))
  end

  it "renders the edit public_profile form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", public_profile_path(@public_profile), "post" do
      assert_select "textarea#public_profile_head_line[name=?]", "public_profile[head_line]"
      assert_select "textarea#public_profile_profile_message[name=?]", "public_profile[profile_message]"
      assert_select "textarea#public_profile_demographic_description[name=?]", "public_profile[demographic_description]"
      assert_select "input#public_profile_cause[name=?]", "public_profile[cause]"
      assert_select "input#public_profile_min_pledge[name=?]", "public_profile[min_pledge]"
      assert_select "input#public_profile_min_click_donation[name=?]", "public_profile[min_click_donation]"
      assert_select "input#public_profile_donations_kind[name=?]", "public_profile[donations_kind]"
      assert_select "input#public_profile_name[name=?]", "public_profile[name]"
      assert_select "input#public_profile_contact_name[name=?]", "public_profile[contact_name]"
      assert_select "input#public_profile_website[name=?]", "public_profile[website]"
      assert_select "input#public_profile_phone[name=?]", "public_profile[phone]"
      assert_select "input#public_profile_email[name=?]", "public_profile[email]"
      assert_select "input#public_profile_banner[name=?]", "public_profile[banner]"
      assert_select "input#public_profile_avatar[name=?]", "public_profile[avatar]"
    end
  end
end
