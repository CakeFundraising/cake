class FundraisersController < InheritedResources::Base
  respond_to :html
  respond_to :js, only: :update

  def new
    @fundraiser = Fundraiser.new
    @fundraiser.build_location
  end

  def create
    @fundraiser = Fundraiser.new(*resource_params)
    @fundraiser.build_location(resource_params.first['location_attributes'])
    @fundraiser.manager = current_user
    create!
    current_user.set_fundraiser(@fundraiser)
    session[:new_user] = nil if session[:new_user]
  end

  def permitted_params
    params.permit(fundraiser: 
      [:cause, :name, :mission, :manager_title, :supporter_demographics, 
       :manager_email, :min_pledge, :min_click_donation, :donations_kind, 
       :unsolicited_pledges, :manager_name, :manager_website, :manager_phone, 
       :tax_exempt, :organization_name, :phone, :email, :website, 
       location_attributes: [:address, :city, :zip_code, :state_code, :country_code],
       picture_attributes: [:banner, :avatar, :avatar_caption, :banner_caption] ])
  end
end
