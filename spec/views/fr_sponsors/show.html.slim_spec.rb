require 'spec_helper'

describe "fr_sponsors/show" do
  before(:each) do
    @fr_sponsor = assign(:fr_sponsor, stub_model(FrSponsor,
      :name => "Name",
      :email => "Email",
      :website_url => "Website Url",
      :fundraiser_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Email/)
    rendered.should match(/Website Url/)
    rendered.should match(/1/)
  end
end
