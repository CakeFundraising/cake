# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :charge do
    stripe_id "MyString"
    kind "MyString"
    amount ""
    total_fee ""
    fee_details '{"foo":"bar"}'
    chargeable_type "MyString"
    chargeable_id 1
  end
end
