class CampaignsController < InheritedResources::Base
  authorize_resource
  before_action :check_if_uncompleted, only: :launch_wizard

  WIZARD_STEPS = [
    :basic_info,
    :tell_your_story,
    :sponsors,
    :launch_wizard,
    :share
  ]

  include ImpressionablesController
  include PastResource

  def show
    @sponsor_categories = resource.sponsor_categories.order(min_value_cents: :desc).decorate
    @campaign = resource.decorate
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

  def destroy
    destroy! do |success, failure|
      success.html do
        redirect_to fundraiser_campaigns_path, notice: 'Campaign was successfully destroyed.'
      end
    end
  end

  #Campaign wizard steps
  def basic_info
    @campaign = resource
    render 'campaigns/form/basic_info'
  end

  def tell_your_story
    @campaign = resource
    render 'campaigns/form/tell_your_story'
  end

  def sponsors
    @sponsor_categories = resource.sponsor_categories.any? ? resource.sponsor_categories.order(min_value_cents: :desc) : resource.sponsor_categories.build(name: '', min_value_cents: 5000)
    @campaign = resource.decorate
    render 'campaigns/form/sponsors'
  end

  def launch_wizard
    @campaign = resource.decorate
    render 'campaigns/form/launch'
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

  #actions
  def save_for_launch
    resource.pending!
    redirect_to share_campaign_path(resource), notice: 'Campaign saved!'
  end

  def launch
    resource.launch!
    redirect_to share_campaign_path(resource), notice: 'Campaign is launched now!'
  end

  protected

  def permitted_params
    params.permit(campaign: [:title, :mission, :launch_date, :end_date, :story, :custom_pledge_levels, :goal, 
    :headline, :step, :main_cause, causes: [], scopes: [], video_attributes: [:id, :url],
    picture_attributes: [
      :id, :banner, :avatar, :avatar_caption,
      :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h,
      :banner_crop_x, :banner_crop_y, :banner_crop_w, :banner_crop_h
    ], 
    sponsor_categories_attributes: [:id, :name, :min_value, :max_value, :position, :_destroy]
    ])
  end

  def check_if_uncompleted
    redirect_to edit_campaign_path(resource), alert: "This campaign can't be launched again." unless resource.uncompleted?
  end
end
