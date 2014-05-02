# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :fundraiser_email_setting do
    new_pledge false
    pledge_increased false
    pledge_fully_subscribed false
    campaign_end false
    missed_launch_campaign false
    account_change false
    public_profile_change false
    campaign_result_summary false
  end
end
