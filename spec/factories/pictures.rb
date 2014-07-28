# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :picture do
    if Rails.env.test?
      avatar { Rack::Test::UploadedFile.new(File.join(Rails.root, "db/seeds/support/images/avatar.jpg")) }
      banner { Rack::Test::UploadedFile.new(File.join(Rails.root, "db/seeds/support/images/banner.jpg")) }
    else
      remote_avatar_url "http://ofertas.rogersoto.com/images/avatar.png"
      remote_banner_url "http://blogs.mydevstaging.com/blogs/cooking/files/2012/05/Coke.jpg"
    end
  end
end
