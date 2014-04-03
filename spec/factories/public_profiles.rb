# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :public_profile do
    head_line "MyText"
    profile_message "MyText"
    demographic_description "MyText"
    cause "MyString"
    min_pledge ""
    min_click_donation "MyString"
    donations_kind "MyString"
    name "MyString"
    contact_name "MyString"
    website "MyString"
    phone "MyString"
    email "MyString"
    banner "MyString"
    avatar "MyString"
  end
end
