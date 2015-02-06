require 'rails_helper'

describe "sponsors/show" do
  before(:each) do
    @sponsor = assign(:sponsor, stub_model(Sponsor,
      :mission => "MyText",
      :customer_demographics => "MyText",
      :manager_name => "Manager Name",
      :manager_title => "Manager Title",
      :manager_email => "Manager Email",
      :manager_phone => "Manager Phone",
      :name => "Name",
      :phone => "Phone",
      :website => "Website",
      :email => "Email",
      :cause_requirements_mask => 1,
      :campaign_scopes_mask => 2,
      :causes_mask => 3,
      :manager_id => 4
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/Manager Name/)
    rendered.should match(/Manager Title/)
    rendered.should match(/Manager Email/)
    rendered.should match(/Manager Phone/)
    rendered.should match(/Name/)
    rendered.should match(/Phone/)
    rendered.should match(/Website/)
    rendered.should match(/Email/)
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/4/)
  end
end
