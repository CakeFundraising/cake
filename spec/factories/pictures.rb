# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :picture do
    avatar "MyString"
    banner "MyString"
    picturable_type "MyString"
    picturable_id 1
  end
end
