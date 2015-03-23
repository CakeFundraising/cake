require 'rails_helper'

RSpec.describe "cakesters/index", :type => :view do
  before(:each) do
    assign(:cakesters, [
      Cakester.create!(
        :name => "Name",
        :email => "Email",
        :phone => "Phone",
        :website => "",
        :manager_name => "Manager Name",
        :manager_email => "Manager Email",
        :manager_title => "Manager Title",
        :manager_phone => "Manager Phone",
        :mission => "MyText",
        :about => "MyText",
        :causes_mask => 1,
        :scopes_mask => 2,
        :cause_requirements_mask => 3,
        :email_subscribers => "Email Subscribers",
        :facebook_subscribers => "Facebook Subscribers",
        :twitter_subscribers => "Twitter Subscribers",
        :pinterest_subscribers => "Pinterest Subscribers"
      ),
      Cakester.create!(
        :name => "Name",
        :email => "Email",
        :phone => "Phone",
        :website => "",
        :manager_name => "Manager Name",
        :manager_email => "Manager Email",
        :manager_title => "Manager Title",
        :manager_phone => "Manager Phone",
        :mission => "MyText",
        :about => "MyText",
        :causes_mask => 1,
        :scopes_mask => 2,
        :cause_requirements_mask => 3,
        :email_subscribers => "Email Subscribers",
        :facebook_subscribers => "Facebook Subscribers",
        :twitter_subscribers => "Twitter Subscribers",
        :pinterest_subscribers => "Pinterest Subscribers"
      )
    ])
  end

  it "renders a list of cakesters" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Manager Name".to_s, :count => 2
    assert_select "tr>td", :text => "Manager Email".to_s, :count => 2
    assert_select "tr>td", :text => "Manager Title".to_s, :count => 2
    assert_select "tr>td", :text => "Manager Phone".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Email Subscribers".to_s, :count => 2
    assert_select "tr>td", :text => "Facebook Subscribers".to_s, :count => 2
    assert_select "tr>td", :text => "Twitter Subscribers".to_s, :count => 2
    assert_select "tr>td", :text => "Pinterest Subscribers".to_s, :count => 2
  end
end
