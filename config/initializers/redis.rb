Dir[Rails.root.join('app/jobs/*.rb')].each { |file| require file }

if Rails.env.development?
  Resque.redis = 'localhost:6379' 
else
  uri = URI.parse(ENV["REDISTOGO_URL"])
  Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true)
end 

Resque.schedule = YAML.load_file(Rails.root.join('config/schedule.yml'))