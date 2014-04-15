require 'spec_helper'

describe "campaigns/new" do
  before(:each) do
    assign(:campaign, stub_model(Campaign,
      :title => "MyString",
      :launch_date => "MyString",
      :end_date => "MyString",
      :cause => "MyString",
      :headline => "MyString",
      :story => "MyText",
      :status => "MyString",
      :fundraiser_id => 1
    ).as_new_record)
  end

  it "renders new campaign form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", campaigns_path, "post" do
      assert_select "input#campaign_title[name=?]", "campaign[title]"
      assert_select "input#campaign_launch_date[name=?]", "campaign[launch_date]"
      assert_select "input#campaign_end_date[name=?]", "campaign[end_date]"
      assert_select "input#campaign_cause[name=?]", "campaign[cause]"
      assert_select "input#campaign_headline[name=?]", "campaign[headline]"
      assert_select "textarea#campaign_story[name=?]", "campaign[story]"
      assert_select "input#campaign_status[name=?]", "campaign[status]"
      assert_select "input#campaign_fundraiser_id[name=?]", "campaign[fundraiser_id]"
    end
  end
end
