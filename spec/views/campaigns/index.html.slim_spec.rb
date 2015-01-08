require 'rails_helper'

describe "campaigns/index" do
  before(:each) do
    assign(:campaigns, [
      stub_model(Campaign,
        :title => "Title",
        :launch_date => "Launch Date",
        :end_date => "End Date",
        :cause => "Cause",
        :headline => "Headline",
        :story => "MyText",
        :status => "Status",
        :fundraiser_id => 1
      ),
      stub_model(Campaign,
        :title => "Title",
        :launch_date => "Launch Date",
        :end_date => "End Date",
        :cause => "Cause",
        :headline => "Headline",
        :story => "MyText",
        :status => "Status",
        :fundraiser_id => 1
      )
    ])
  end

  it "renders a list of campaigns" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Launch Date".to_s, :count => 2
    assert_select "tr>td", :text => "End Date".to_s, :count => 2
    assert_select "tr>td", :text => "Cause".to_s, :count => 2
    assert_select "tr>td", :text => "Headline".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
