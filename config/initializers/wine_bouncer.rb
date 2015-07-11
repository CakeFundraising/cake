WineBouncer.configure do |config|
  config.auth_strategy = :swagger

  config.define_resource_owner do
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
