module API
  module V1
    class Users < API::V1::Root
      include API::V1::Defaults

      resource :users do

        desc "Return current_user's data"
        get :me, jbuilder: 'users/show' do
          @user = current_user
          @token = current_token
        end

        desc "Return user's data given an UID"
        params do
          requires :id, type: Integer, desc: "User ID"
        end
        route_param :id do
          get jbuilder: 'users/show' do
            @user = User.find(params[:id])
          end
        end

      end

    end
  end
end