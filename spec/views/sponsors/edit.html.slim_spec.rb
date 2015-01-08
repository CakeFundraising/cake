require 'rails_helper'

describe "sponsors/edit" do
  before(:each) do
    @sponsor = assign(:sponsor, stub_model(Sponsor,
      :mission => "MyText",
      :customer_demographics => "MyText",
      :manager_name => "MyString",
      :manager_title => "MyString",
      :manager_email => "MyString",
      :manager_phone => "MyString",
      :name => "MyString",
      :phone => "MyString",
      :website => "MyString",
      :email => "MyString",
      :cause_requirements_mask => 1,
      :campaign_scopes_mask => 1,
      :causes_mask => 1,
      :manager_id => 1
    ))
  end

  it "renders the edit sponsor form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", sponsor_path(@sponsor), "post" do
      assert_select "textarea#sponsor_mission[name=?]", "sponsor[mission]"
      assert_select "textarea#sponsor_customer_demographics[name=?]", "sponsor[customer_demographics]"
      assert_select "input#sponsor_manager_name[name=?]", "sponsor[manager_name]"
      assert_select "input#sponsor_manager_title[name=?]", "sponsor[manager_title]"
      assert_select "input#sponsor_manager_email[name=?]", "sponsor[manager_email]"
      assert_select "input#sponsor_manager_phone[name=?]", "sponsor[manager_phone]"
      assert_select "input#sponsor_name[name=?]", "sponsor[name]"
      assert_select "input#sponsor_phone[name=?]", "sponsor[phone]"
      assert_select "input#sponsor_website[name=?]", "sponsor[website]"
      assert_select "input#sponsor_email[name=?]", "sponsor[email]"
      assert_select "input#sponsor_cause_requirements_mask[name=?]", "sponsor[cause_requirements_mask]"
      assert_select "input#sponsor_campaign_scopes_mask[name=?]", "sponsor[campaign_scopes_mask]"
      assert_select "input#sponsor_causes_mask[name=?]", "sponsor[causes_mask]"
      assert_select "input#sponsor_manager_id[name=?]", "sponsor[manager_id]"
    end
  end
end
