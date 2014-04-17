# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :coupon do
    title "MyString"
    expires_at "2014-04-17 11:15:23"
    promo_code "MyString"
    description "MyText"
    terms_conditions "MyText"
    avatar "MyString"
    qrcode "MyString"
    pledge_id 1
  end
end
