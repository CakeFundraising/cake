module V1
  class Users < Grape::API
    helpers Doorkeeper::Grape::Helpers

    before do
      doorkeeper_authorize!
    end

    resource :users do
      # get do
      #   ::User.all
      # end

      get 'me' do
        resource_owner_authenticator
      end
    end
  end
end