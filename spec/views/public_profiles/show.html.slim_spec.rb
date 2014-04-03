require 'spec_helper'

describe "public_profiles/show" do
  before(:each) do
    @public_profile = assign(:public_profile, stub_model(PublicProfile,
      :head_line => "MyText",
      :profile_message => "MyText",
      :demographic_description => "MyText",
      :cause => "Cause",
      :min_pledge => "",
      :min_click_donation => "Min Click Donation",
      :donations_kind => "Donations Kind",
      :name => "Name",
      :contact_name => "Contact Name",
      :website => "Website",
      :phone => "Phone",
      :email => "Email",
      :banner => "Banner",
      :avatar => "Avatar"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/Cause/)
    rendered.should match(//)
    rendered.should match(/Min Click Donation/)
    rendered.should match(/Donations Kind/)
    rendered.should match(/Name/)
    rendered.should match(/Contact Name/)
    rendered.should match(/Website/)
    rendered.should match(/Phone/)
    rendered.should match(/Email/)
    rendered.should match(/Banner/)
    rendered.should match(/Avatar/)
  end
end
