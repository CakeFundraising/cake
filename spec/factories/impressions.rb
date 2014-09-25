# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :impression do
    impressionable_type "MyString"
    impressionable_id 1
    view "MyString"
    ip "MyString"
    user_agent "MyString"
    http_encoding "MyString"
    http_language "MyString"
    browser_plugins "MyText"
  end
end
