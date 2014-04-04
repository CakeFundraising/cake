# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    avatar "MyString"
    name "MyString"
    phone "MyString"
    website "MyString"
    email "MyString"
    user_id 1
  end
end
