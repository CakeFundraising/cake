# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :fundraiser do
    banner "MyString"
    avatar "MyString"
    cause "MyString"
    min_pledge 1
    min_click_donation 1
    donations_kind false
    tax_exempt false
    unsolicited_pledges false
    manager_name "MyString"
    manager_title "MyString"
    manager_email "MyString"
    manager_phone "MyString"
    name "MyString"
    mission "MyText"
    supporter_demographics "MyText"
    organization_name "MyString"
    phone "MyString"
    website "MyString"
    email "MyString"
  end
end
