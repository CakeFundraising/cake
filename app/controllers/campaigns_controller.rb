class CampaignsController < InheritedResources::Base
  authorize_resource
  
  WIZARD_STEPS = [
    :basic_info,
    :tell_your_story,
    :sponsors,
    :share
  ]

  def show
    @campaign = resource.decorate
    @sponsor_categories = @campaign.sponsor_categories.decorate
    @campaign.rank_levels

    redirect_if_turbolinks_to(@campaign)
  end

  def create
    @campaign = current_fundraiser.campaigns.build(*resource_params)

    create! do |success, failure|
      success.html do
        redirect_to tell_your_story_campaign_path(@campaign)
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
  def basic_info
    @campaign = resource
    render 'campaigns/form/basic_info'
  end

  def tell_your_story
    @campaign = resource
    render 'campaigns/form/tell_your_story'
  end

  def sponsors
    @campaign = resource
    @campaign.sponsor_categories.build unless @campaign.sponsor_categories.any?
    render 'campaigns/form/sponsors'
  end

  def share
    @campaign = resource.decorate
    render 'campaigns/form/share'
  end

  def badge
    @campaign = resource.decorate
    render layout: false
    response.headers.except! 'X-Frame-Options'
  end

  def pledge
    if current_sponsor.present?
      redirect_to new_pledge_path(campaign: resource)
    else
      cookies[:pledge_campaign] = resource.id
      sign_out current_user if current_user.present?
      redirect_to new_user_registration_path(role: :sponsor), alert: "To pledge this campaign first you have to register."
    end
  end

  def launch
    resource.launch!
    redirect_to resource, notice: 'Campaign is live now!'
  end

  protected

  def permitted_params
    params.permit(campaign: [:title, :mission, :launch_date, :end_date, :story, :custom_pledge_levels, :headline, :step, 
    causes: [], scopes: [], video_attributes: [:id, :url],
    picture_attributes: [:id, :banner, :avatar, :avatar_caption, :banner_cache, :avatar_cache], 
    sponsor_categories_attributes: [:id, :name, :min_value, :max_value, :_destroy]
    ])
  end
end
