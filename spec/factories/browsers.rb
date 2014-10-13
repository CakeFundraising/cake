# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :browser do
    ip ""
    ua ""
    http_language ""
    http_encoding ""
    plugins "MyText"
    user_id 1
  end
end
