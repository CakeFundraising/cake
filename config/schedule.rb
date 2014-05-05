# Learn more: http://github.com/javan/whenever

every :day, at: '4:30 am' do
  rake "cake:end_campaigns"
  rake "cake:notify_missed_campaign_launch"
end