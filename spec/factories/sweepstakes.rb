# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sweepstake do
    title "MyString"
    winners_quantity 1
    claim_prize_instructions "MyText"
    description "MyText"
    terms_conditions "MyText"
    avatar "MyString"
    pledge_id 1
  end
end
