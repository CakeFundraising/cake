# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :click do
    pledge
    browser

    factory :firefox_click do
      association :browser, factory: :firefox_browser
    end
  end
end
