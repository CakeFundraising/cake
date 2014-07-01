web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
resque: env QUEUE=* TERM_CHILD=1 bundle exec rake resque:work
scheduler: bundle exec rake resque:scheduler