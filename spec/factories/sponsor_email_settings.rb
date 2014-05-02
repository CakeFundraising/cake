# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sponsor_email_setting do
    new_pledge_request false
    pledge_increased false
    pledge_fully_subscribed false
    pledge_accepted false
    pledge_rejected false
    account_change false
    public_profile_change false
    campaign_lauch false
    campaign_end false
    missed_launch_campaign false
    sponsor_id 1
  end
end
