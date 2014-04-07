class FundraisersController < InheritedResources::Base
  respond_to :html
  respond_to :js, only: :update

  def permitted_params
    params.permit(fundraiser: 
      [:cause, :name, :mission, :manager_title, :supporter_demographics, 
       :manager_email, :min_pledge, :min_click_donation, :donations_kind, :manager_name, 
       :manager_website, :manager_phone, :banner, :remove_banner, :tax_exempt, :organization_name, 
       :avatar, :phone, :email, :website, :remove_avatar,
       location_attributes: [:address, :city, :zip_code, :state_code, :country_code] ])
  end
end
