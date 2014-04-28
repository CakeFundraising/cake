require 'spec_helper'

describe "sponsor/dashboard/pledge_requests" do
  let(:sponsor){ FactoryGirl.create(:sponsor) }
  let(:pledge_requests) { create_list(:pledge_request, 3, sponsor: sponsor) }

  before(:each) do
    render 
  end

  it "renders the FR requests table" do
    # Header
    rendered.should have_selector("table#requested_pledges thead tr", text: PledgeRequest.human_attribute_name(:campaign))
    rendered.should have_selector("table#requested_pledges thead tr", text: PledgeRequest.human_attribute_name(:causes))
    rendered.should have_selector("table#requested_pledges thead tr", text: PledgeRequest.human_attribute_name(:scopes))
    rendered.should have_selector("table#requested_pledges thead tr", text: PledgeRequest.human_attribute_name(:start_end_dates))
  end
end