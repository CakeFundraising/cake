# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :click do
    pledge
    browser

    factory :bonus_click do
      bonus true
    end
  end
end
