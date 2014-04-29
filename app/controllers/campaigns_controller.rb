class CampaignsController < InheritedResources::Base
  authorize_resource
  
  WIZARD_STEPS = [
    :tell_your_story,
    :sponsors,
    :share
  ]

  def show
    @campaign = resource.decorate
  end

  def create
    @campaign = current_fundraiser.campaigns.build(*resource_params)

    create! do |success, failure|
      success.html do
        redirect_to sponsors_campaign_path(@campaign)
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
      failure.html do
        step_action = WIZARD_STEPS[WIZARD_STEPS.index(params[:campaign][:step].to_sym)-1].to_s
        render 'campaigns/form/' + step_action
      end
    end
  end

  #Non restful actions
  def tell_your_story
    @campaign = resource
    render 'campaigns/form/main'
  end

  def sponsors
    @campaign = resource
    @campaign.sponsor_categories.build unless @campaign.sponsor_categories.any?
    render 'campaigns/form/sponsors'
  end

  def share
    @campaign = resource
    render 'campaigns/form/share'
  end

  def badge
    @campaign = resource.decorate
    render layout: false
    response.headers.except! 'X-Frame-Options'
  end

  def pledge
    if current_sponsor.present?
      redirect_to new_pledge_path
    else
      cookies[:pledge_campaign] = resource.id
      sign_out current_user if current_user.present?
      redirect_to new_user_registration_path(role: :sponsor), warning: "To pledge this campaign first you have to register."
    end
  end

  protected

  def permitted_params
    params.permit(campaign: [:title, :launch_date, :end_date, :story, :no_sponsor_categories, :headline, :step, 
    causes: [], scopes: [], video_attributes: [:id, :url],
    picture_attributes: [:id, :banner, :avatar, :avatar_caption, :banner_cache, :avatar_cache], 
    sponsor_categories_attributes: [:id, :name, :min_value, :max_value, :_destroy]
    ])
  end
end
