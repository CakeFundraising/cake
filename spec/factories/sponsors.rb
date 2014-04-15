# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sponsor do
    mission "MyText"
    customer_demographics "MyText"
    manager_name "MyString"
    manager_title "MyString"
    manager_email "MyString"
    manager_phone "MyString"
    name "MyString"
    phone "MyString"
    website "MyString"
    email "MyString"
    cause_requirements_mask 1
    campaign_scopes_mask 1
    causes_mask 1
    manager_id 1
  end
end
