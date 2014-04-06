class Settings::FundraiserProfilesController < InheritedResources::Base
  respond_to :html
  respond_to :js, only: :update
  before_action :set_organization, only: [:edit, :show]

  def update
    update! do |success, failure|
      @organization = current_user.organization
    end
  end

  def permitted_params
    params.permit(fundraiser_profile: 
      [:cause, :name, :mission, :contact_title, :supporter_demographic, 
       :contact_email, :min_pledge, :min_click_donation, :donations_kind, :contact_name, 
       :contact_website, :contact_phone, :banner, :remove_banner, :tax_exempt ])
  end

  private

  def set_organization
    @organization = current_user.organization
  end
end
