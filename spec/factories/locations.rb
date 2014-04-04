# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
    address "MyString"
    country "MyString"
    state "MyString"
    zip_code "MyString"
    city "MyString"
    locatable nil
    name "MyString"
  end
end
