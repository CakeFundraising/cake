class FrSponsorsController < InheritedResources::Base
  def index
    @fr_sponsors = current_fundraiser.fr_sponsors.latest.decorate
  end

  def create
    @fr_sponsor = FrSponsor.new(*resource_params)
    @fr_sponsor.fundraiser = current_fundraiser
    @fr_sponsor.build_location(resource_params.first['location_attributes'])

    create! do |success, failure|
      success.html do
        redirect_to fr_sponsors_path, notice: 'Sponsor created succesfully.'
      end
    end
  end

  def update
    update! do |success, failure|
      success.html do
        redirect_to fr_sponsors_path, notice: 'Sponsor updated succesfully.'
      end
    end
  end

  private

  def permitted_params
    params.permit(
      fr_sponsor: [
        :name, :email, :website_url, :picture_permission,
        location_attributes: [:address, :city, :zip_code, :state_code, :country_code],
        picture_attributes: [
          :id, :banner, :avatar, :avatar_caption,
          :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h,
          :banner_crop_x, :banner_crop_y, :banner_crop_w, :banner_crop_h
        ]
      ]
    )
  end
end
