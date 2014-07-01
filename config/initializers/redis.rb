Dir[Rails.root.join('app/jobs/*.rb')].each { |file| require file }

if Rails.env.development?
  Resque.redis = 'localhost:6379' 
else
  ENV["REDISTOGO_URL"] ||= "redis://redistogo:c75abdb531a416f7a9227c526b77f7a9@grideye.redistogo.com:10941/"
  uri = URI.parse(ENV["REDISTOGO_URL"])
  Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true)
end 

Resque.schedule = YAML.load_file(Rails.root.join('config/cake_schedule.yml'))