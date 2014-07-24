# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :click do
    request_ip { Faker::Internet.ip_v4_address }
    user_agent 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36'
    http_encoding 'gzip,deflate,sdch'
    http_language 'es-419,es;q=0.8,en;q=0.6'
    browser_plugins 'Widevine Content Decryption Module,Shockwave Flash,Chrome Remote Desktop Viewer,Native Client,Chrome PDF Viewer,Default Browser Helper,Shockwave Flash,Google Talk Plugin,Google Talk Plugin Video Renderer,QuickTime Plug-in 7.7.3'
    email { Faker::Internet.email }
    pledge
  end
end
