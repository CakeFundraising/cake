class FrSponsorsController < InheritedResources::Base
  def create
    @fr_sponsor = FrSponsor.new(*resource_params)
    @fr_sponsor.fundraiser = current_fundraiser
    @fr_sponsor.build_location(resource_params.first['location_attributes'])

    create! do |success, failure|
      success.html do
        redirect_to quick_pledges_path, notice: 'Sponsor created succesfully.'
      end
    end
  end

  def update
    update! do |success, failure|
      success.html do
        redirect_to quick_pledges_path, notice: 'Sponsor updated succesfully.'
      end
    end
  end

  private

  def permitted_params
    params.permit(
      fr_sponsor: [
        :name, :email, :website_url, :picture_permission,
        location_attributes: [:address, :city, :zip_code, :state_code, :country_code]
      ]
    )
  end
end
