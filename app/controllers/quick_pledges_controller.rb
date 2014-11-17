class QuickPledgesController < InheritedResources::Base
  def index
    @fr_sponsors = current_fundraiser.fr_sponsors.latest.decorate
  end

  def create
    create! do |success, failure|
      success.html do
        redirect_to quick_pledges_path, notice: 'Pledge created succesfully.'
      end
    end
  end

  def update
    update! do |success, failure|
      success.html do
        redirect_to quick_pledges_path, notice: 'Pledge updated succesfully.'
      end
    end
  end

  def destroy
    destroy! do |success, failure|
      success.html do
        redirect_to quick_pledges_path, notice: 'Pledge deleted.'
      end
      failure.html do
        redirect_to quick_pledges_path, alert: 'There was an error when deleting this pledge. Please try again.'
      end
    end
  end

  def permitted_params
    params.permit(
      quick_pledge: [
        :name, :donation_per_click, :total_amount, :website_url, :terms, :campaign_id,
        :sponsorable_id, :sponsorable_type,
        picture_attributes: [
          :id, :banner, :avatar, :avatar_caption,
          :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h,
          :banner_crop_x, :banner_crop_y, :banner_crop_w, :banner_crop_h
        ]
      ]
    )
  end
end
