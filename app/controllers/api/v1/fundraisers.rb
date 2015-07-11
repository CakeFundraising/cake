module API
  module V1
    class Fundraisers < API::V1::Root

      resource :fundraisers do

        desc "Return fundraiser's data given an UID"
        params do
          requires :id, type: Integer, desc: "Fundraiser ID", allow_blank: false
        end
        route_param :id do
          get jbuilder: 'fundraisers/show' do
            @fundraiser = Fundraiser.find(params[:id])
          end
        end

      end

    end
  end
end