module API
  module V1
    class Users < API::V1::Root
      include API::V1::Defaults

      # helpers Doorkeeper::Grape::Helpers

      # before do
      #   doorkeeper_authorize!
      # end

      resource :users do
        # get do
        #   ::User.all
        # end

        get 'me' do
          #current_user
          result = {}
        end
      end

    end
  end
end