unless Rails.env.test?
  Dir[Rails.root.join('app/jobs/*.rb')].each { |file| require file }

  if Rails.env.development?
    Resque.redis = 'localhost:6379' 
  elsif Rails.env.production? and ENV["REDISTOGO_URL"].present?
    uri = URI.parse(ENV["REDISTOGO_URL"])
    Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true)

    Resque::Server.use(Rack::Auth::Basic) do |user, password|
      user == ENV["CAKE_RESQUE_SERVER_USER"]
      password == ENV["CAKE_RESQUE_SERVER_PASS"]
    end
  end 

  Resque.schedule = YAML.load_file(Rails.root.join('config/schedule.yml'))
end