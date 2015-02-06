require 'rails_helper'

describe "fr_sponsors/index" do
  before(:each) do
    assign(:fr_sponsors, [
      stub_model(FrSponsor,
        :name => "Name",
        :email => "Email",
        :website_url => "Website Url",
        :fundraiser_id => 1
      ),
      stub_model(FrSponsor,
        :name => "Name",
        :email => "Email",
        :website_url => "Website Url",
        :fundraiser_id => 1
      )
    ])
  end

  it "renders a list of fr_sponsors" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Website Url".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
