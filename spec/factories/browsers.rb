# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :browser do
    ip { Faker::Internet.ip_v4_address }
    ua 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36'
    http_language 'gzip,deflate,sdch'
    http_encoding 'es-419,es;q=0.8,en;q=0.6'
    plugins 'Chrome PDF Viewer,Chrome Remote Desktop Viewer,Default Browser Helper,Google Talk Plugin,Google Talk Plugin Video Renderer,Native Client,QuickTime Plug-in 7.7.3,Shockwave Flash,Shockwave Flash,Widevine Content Decryption Module'

    factory :user_browser do
      user
    end

    factory :firefox_browser do
      ua 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:32.0) Gecko/20100101 Firefox/32.0'
      http_encoding 'gzip, deflate'
      http_language 'es-ar,es;q=0.8,en-us;q=0.5,en;q=0.3'
      plugins 'Default Browser Helper,Google Talk Plugin,Google Talk Plugin Video Renderer,Java Applet Plug-in,QuickTime Plug-in 7.7.3,Shockwave Flash'
    end
  end
end
