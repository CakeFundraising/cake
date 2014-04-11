class CampaignsController < InheritedResources::Base
  respond_to :html
  respond_to :js, only: [:create, :update]

  def show
    @campaign = resource.decorate
  end

  def create
    @campaign = current_fundraiser.campaigns.build(*resource_params)

    create! do |success, failure|
      success.html do
        redirect_to sponsors_and_donations_campaign_path(@campaign)
      end
      failure.html do
        render action: :new
      end
    end
  end

  def update
    update! do |success, failure|
      success.html do
        redirect_to controller: :campaigns, action: params[:campaign][:step], id: resource
      end
    end
  end

  #Non restful actions
  def sponsors_and_donations
    @campaign = resource
    @campaign.sponsor_categories.build
  end

  def share
    @campaign = resource
  end

  def make_visible
    redirect_to resource if resource.make_visible!
  end

  def badge
    @campaign = resource.decorate
    render layout: false
    response.headers.except! 'X-Frame-Options'
  end

  protected

  def permitted_params
    params.permit(campaign: [:title, :launch_date, :end_date, :story, :show_donation, 
    :cause, :no_sponsor_categories, :scope, :headline, :step, 
    picture_attributes: [:banner, :avatar, :avatar_caption, :banner_cache, :avatar_cache], 
    sponsor_categories_attributes: [:id, :name, :min_value, :max_value, :_destroy],
    video_attributes: [:url] 
    ])
  end
end
