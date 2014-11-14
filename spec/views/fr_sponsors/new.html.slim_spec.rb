require 'spec_helper'

describe "fr_sponsors/new" do
  before(:each) do
    assign(:fr_sponsor, stub_model(FrSponsor,
      :name => "MyString",
      :email => "MyString",
      :website_url => "MyString",
      :fundraiser_id => 1
    ).as_new_record)
  end

  it "renders new fr_sponsor form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", fr_sponsors_path, "post" do
      assert_select "input#fr_sponsor_name[name=?]", "fr_sponsor[name]"
      assert_select "input#fr_sponsor_email[name=?]", "fr_sponsor[email]"
      assert_select "input#fr_sponsor_website_url[name=?]", "fr_sponsor[website_url]"
      assert_select "input#fr_sponsor_fundraiser_id[name=?]", "fr_sponsor[fundraiser_id]"
    end
  end
end
