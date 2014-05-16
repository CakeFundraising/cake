# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :charge do
    stripe_id "MyString"
    kind "MyString"
    amount ""
    total_fee ""
    status "MyString"
    available_on "2014-05-16 13:22:54"
    fee_details ""
    chargeable_type "MyString"
    chargeable_id 1
  end
end
