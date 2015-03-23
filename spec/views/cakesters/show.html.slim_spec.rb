require 'rails_helper'

RSpec.describe "cakesters/show", :type => :view do
  before(:each) do
    @cakester = assign(:cakester, Cakester.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Phone/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Manager Name/)
    expect(rendered).to match(/Manager Email/)
    expect(rendered).to match(/Manager Title/)
    expect(rendered).to match(/Manager Phone/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Email Subscribers/)
    expect(rendered).to match(/Facebook Subscribers/)
    expect(rendered).to match(/Twitter Subscribers/)
    expect(rendered).to match(/Pinterest Subscribers/)
  end
end
