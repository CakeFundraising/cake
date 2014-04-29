require 'spec_helper'

feature 'Pledge Permissions' do
  given(:sponsor){ FactoryGirl.create(:sponsor) }
  given(:fundraiser){ FactoryGirl.create(:fundraiser) }
  given(:campaign){ FactoryGirl.create(:campaign, fundraiser: fundraiser) }
  given(:pledge){ FactoryGirl.create(:pledge, sponsor: sponsor, campaign: campaign) }

  background do
    login_user(sponsor.manager)
  end

  context 'Sponsor Permissions' do
    background do
      @other_pledge = FactoryGirl.create(:pledge)
    end

    scenario "cannot edit another sponsor's pledges" do
      visit edit_pledge_path(@other_pledge)
      page.should have_content('You are not authorized to perform this action')
    end
  end
end