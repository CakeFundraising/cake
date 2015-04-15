require 'doorkeeper/grape/helpers'

module V1
  class Init < Grape::API
    mount V1::Users
  end
end