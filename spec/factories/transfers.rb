# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transfer do
    stripe_id "MyString"
    balance_transaction_id "MyString"
    kind "MyString"
    amount ""
    total_fee ""
    status "MyString"
    transferable_type "MyString"
    transferable_id 1
  end
end
