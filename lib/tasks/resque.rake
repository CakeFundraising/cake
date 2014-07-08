# Resque tasks
require 'resque/tasks'
require 'resque_scheduler/tasks'

namespace :resque do
  task setup: :environment
  task scheduler_setup: :environment
end

desc "Alias for resque:work (To run workers on Heroku)"
task "jobs:work" => "resque:work"