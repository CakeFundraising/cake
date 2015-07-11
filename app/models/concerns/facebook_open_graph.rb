module FacebookOpenGraph
  extend ActiveSupport::Concern
  
  def self.clear_cache(url)
    params = {
      :client_id => ENV['FB_APP_ID'],
      :client_secret => ENV['FB_APP_SECRET'],
      :grant_type => "client_credentials"
    }

    uri = URI("https://graph.facebook.com/oauth/access_token?#{params.to_query}")
    response = Net::HTTP.get(uri)
    access_token = Rack::Utils.parse_nested_query(response)["access_token"]
    
    unless access_token.nil?
      uri = URI('https://graph.facebook.com')
      res = Net::HTTP.post_form(uri, id: url, scrape: true, access_token: access_token, max: 500)
    end 
  end
end