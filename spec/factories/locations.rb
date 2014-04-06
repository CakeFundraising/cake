# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
    address "MyString"
    country_code "MyString"
    state_code "MyString"
    zip_code "MyString"
    city "MyString"
    locatable nil
    name "MyString"
  end
end
