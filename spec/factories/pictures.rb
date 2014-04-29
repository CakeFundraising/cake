# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :picture do
    avatar { Rack::Test::UploadedFile.new(File.join(Rails.root, "db/seeds/support/images/avatar.jpg")) }
    banner { Rack::Test::UploadedFile.new(File.join(Rails.root, "db/seeds/support/images/banner.jpg")) }
  end
end
