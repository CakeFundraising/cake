module FacebookOpenGraph
  def self.clear_cache(url)
    params = {
      #Replace with Heroko ENV Vars when going live.
      #:client_id => ENV['FB_APP_ID'],
      #:client_secret => ENV['FB_APP_SECRET'],
      
      :client_id => "791527620880364",
      :client_secret => "db2c185e03ec70dd3d899791b3d68102",
      :grant_type => "client_credentials"
    }
    uri = URI("https://graph.facebook.com/oauth/access_token?#{params.to_query}")
    response = Net::HTTP.get(uri)
    access_token = Rack::Utils.parse_nested_query(response)["access_token"]
    
    unless access_token.nil?
      uri = URI('https://graph.facebook.com')
      res = Net::HTTP.post_form(uri, 'id' => "#{url}", 'scrape' => 'true',
          'access_token' => "#{access_token}", 'max' => '500')
    end 
  end
end