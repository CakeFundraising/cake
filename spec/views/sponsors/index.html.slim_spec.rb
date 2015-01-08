require 'rails_helper'

describe "sponsors/index" do
  before(:each) do
    assign(:sponsors, [
      stub_model(Sponsor,
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
      ),
      stub_model(Sponsor,
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
      )
    ])
  end

  it "renders a list of sponsors" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Manager Name".to_s, :count => 2
    assert_select "tr>td", :text => "Manager Title".to_s, :count => 2
    assert_select "tr>td", :text => "Manager Email".to_s, :count => 2
    assert_select "tr>td", :text => "Manager Phone".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    assert_select "tr>td", :text => "Website".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
  end
end
