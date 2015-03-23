require 'rails_helper'

RSpec.describe "cakesters/new", :type => :view do
  before(:each) do
    assign(:cakester, Cakester.new(
      :name => "MyString",
      :email => "MyString",
      :phone => "MyString",
      :website => "",
      :manager_name => "MyString",
      :manager_email => "MyString",
      :manager_title => "MyString",
      :manager_phone => "MyString",
      :mission => "MyText",
      :about => "MyText",
      :causes_mask => 1,
      :scopes_mask => 1,
      :cause_requirements_mask => 1,
      :email_subscribers => "MyString",
      :facebook_subscribers => "MyString",
      :twitter_subscribers => "MyString",
      :pinterest_subscribers => "MyString"
    ))
  end

  it "renders new cakester form" do
    render

    assert_select "form[action=?][method=?]", cakesters_path, "post" do

      assert_select "input#cakester_name[name=?]", "cakester[name]"

      assert_select "input#cakester_email[name=?]", "cakester[email]"

      assert_select "input#cakester_phone[name=?]", "cakester[phone]"

      assert_select "input#cakester_website[name=?]", "cakester[website]"

      assert_select "input#cakester_manager_name[name=?]", "cakester[manager_name]"

      assert_select "input#cakester_manager_email[name=?]", "cakester[manager_email]"

      assert_select "input#cakester_manager_title[name=?]", "cakester[manager_title]"

      assert_select "input#cakester_manager_phone[name=?]", "cakester[manager_phone]"

      assert_select "textarea#cakester_mission[name=?]", "cakester[mission]"

      assert_select "textarea#cakester_about[name=?]", "cakester[about]"

      assert_select "input#cakester_causes_mask[name=?]", "cakester[causes_mask]"

      assert_select "input#cakester_scopes_mask[name=?]", "cakester[scopes_mask]"

      assert_select "input#cakester_cause_requirements_mask[name=?]", "cakester[cause_requirements_mask]"

      assert_select "input#cakester_email_subscribers[name=?]", "cakester[email_subscribers]"

      assert_select "input#cakester_facebook_subscribers[name=?]", "cakester[facebook_subscribers]"

      assert_select "input#cakester_twitter_subscribers[name=?]", "cakester[twitter_subscribers]"

      assert_select "input#cakester_pinterest_subscribers[name=?]", "cakester[pinterest_subscribers]"
    end
  end
end
