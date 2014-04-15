# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :video do
    recordable_type "MyString"
    recordable_id 1
    url "MyString"
  end
end
