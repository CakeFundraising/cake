class CampaignsController < InheritedResources::Base
  respond_to :html
  respond_to :js, only: [:create, :update]

  def new
    @campaign = current_fundraiser.campaigns.create
    redirect_to edit_campaign_path(@campaign)
  end


  def update
    update! do |success, failure|
      success.html do
        redirect_to edit_campaign_path(@campaign, anchor: params[:campaign][:step])
      end
    end
  end

  def make_visible
    redirect_to resource if resource.make_visible!
  end

  def permitted_params
    params.permit(campaign: [:title, :launch_date, :end_date, :story, :show_donation, :cause, :headline, :step, 
    picture_attributes: [:banner, :avatar, :avatar_caption], sponsor_categories_attributes: [:id, :name, :min_value, :max_value, :_destroy] ])
  end
end
