class OrganizationsController < InheritedResources::Base
  respond_to :html
  respond_to :js, only: :update

  def update
    update! do |success, failure|
      @fundraiser_profile = current_user.fundraiser_profile

      success.html do
        redirect_to [:settings, @fundraiser_profile], notice: 'Fundraiser Profile Update successfully.'
      end
      failure.html do 
        render action:'edit'
      end
    end
  end

  def permitted_params
    params.permit(organization: [:name, :avatar, :phone, :email, :website, :remove_avatar,
      location_attributes: [:address, :city, :zip_code, :state_code, :country_code] ])
  end
end