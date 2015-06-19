module API
  module V1
    class Sponsors < API::V1::Root

      resource :sponsors do

        desc "Return sponsor's data given an UID"
        params do
          requires :id, type: Integer, desc: "Sponsor ID", allow_blank: false
        end
        route_param :id do
          get jbuilder: 'sponsors/show' do
            @sponsor = Sponsor.find(params[:id])
          end
        end

      end

    end
  end
end