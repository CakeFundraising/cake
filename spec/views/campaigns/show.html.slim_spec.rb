require 'spec_helper'

describe "campaigns/show" do
  before(:each) do
    @campaign = assign(:campaign, stub_model(Campaign,
      :title => "Title",
      :launch_date => "Launch Date",
      :end_date => "End Date",
      :cause => "Cause",
      :headline => "Headline",
      :story => "MyText",
      :status => "Status",
      :fundraiser_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/Launch Date/)
    rendered.should match(/End Date/)
    rendered.should match(/Cause/)
    rendered.should match(/Headline/)
    rendered.should match(/MyText/)
    rendered.should match(/Status/)
    rendered.should match(/1/)
  end
end
