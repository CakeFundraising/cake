FactoryGirl.define do
  factory :pledge_news do
    headline { Faker::Lorem.sentence }
    story { Faker::Lorem.paragraph }
    url { Faker::Internet.url }
    pledge
  end

end
