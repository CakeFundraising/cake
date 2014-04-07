require 'spec_helper'

describe "fundraisers/show" do
  before(:each) do
    @fundraiser = assign(:fundraiser, stub_model(Fundraiser,
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
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Banner/)
    rendered.should match(/Avatar/)
    rendered.should match(/Cause/)
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/Manager Name/)
    rendered.should match(/Manager Title/)
    rendered.should match(/Manager Email/)
    rendered.should match(/Manager Phone/)
    rendered.should match(/Name/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/Organization Name/)
    rendered.should match(/Phone/)
    rendered.should match(/Website/)
    rendered.should match(/Email/)
  end
end
