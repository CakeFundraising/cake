class PledgesController < InheritedResources::Base
  load_and_authorize_resource
  before_action :allow_only_sponsors, :clear_cookies, only: :new
  before_action :block_fully_subscribed, only: [:edit, :tell_your_story, :add_coupon, :share]

  WIZARD_STEPS = [
    :your_pledge,
    :tell_your_story,
    :add_coupon,
    # :add_sweepstakes,
    :share
  ]

  include ImpressionablesController
  include PastResource
  include PledgesHelper

  #CRUD
  def select_campaign
    @fundraiser = Fundraiser.find(params[:fundraiser]).decorate
    @campaigns = @fundraiser.campaigns.active
  end

  def new
    if params[:campaign].present?
      @pledge = Pledge.new(campaign_id: params[:campaign])
      render 'new'
    elsif params[:fundraiser].present?
      redirect_to select_campaign_pledges_path(fundraiser: params[:fundraiser]), notice: 'Please select one of these campaigns to start a pledge.'
    else
      redirect_to search_campaigns_path, notice: 'Please select one of these campaigns to start a pledge.'
    end
  end

  def show
    @pledge = resource.decorate
    @coupons = @pledge.coupons.latest.decorate
  end

  def create
    @pledge = current_sponsor.pledges.build(*resource_params)

    create! do |success, failure|
      success.html do
        update_pledge_screenshot(@pledge)
        redirect_to tell_your_story_pledge_path(@pledge)
      end
      failure.html do
        step_action = WIZARD_STEPS[WIZARD_STEPS.index(params[:pledge][:step].to_sym)-1].to_s
        render 'pledges/form/' + step_action
      end
    end
  end

  def update
    update! do |success, failure|
      success.html do
        update_pledge_screenshot(resource)
        redirect_to controller: :pledges, action: params[:pledge][:step], id: resource
      end
      failure.html do
        step_action = WIZARD_STEPS[WIZARD_STEPS.index(params[:pledge][:step].to_sym)-1].to_s
        render 'pledges/form/' + step_action
      end
    end
  end

  def destroy
    destroy! do |success, failure|
      success.html do
        if current_sponsor.present?
          redirect_to sponsor_home_path, notice: 'Pledge canceled.'
        else
          redirect_to fundraiser_home_path, notice: 'Pledge canceled.'
        end
      end
    end
  end

  # Pledge wizard
  def tell_your_story
    @pledge = resource
    render 'pledges/form/tell_your_story'
  end

  def add_coupon
    @pledge = resource
    @coupons = @pledge.coupons
    render 'pledges/form/add_coupon'
  end

  def add_sweepstakes
    @pledge = resource
    @pledge.sweepstakes.build unless @pledge.sweepstakes.any?
    render 'pledges/form/add_sweepstakes'
  end

  def share
    @pledge = resource.decorate
    render 'pledges/form/share'
  end

  def badge
    @pledge = resource.decorate
    render layout: false
    response.headers.except! 'X-Frame-Options'
  end

  #Actions
  def accept
    resource.notify_approval if resource.accepted!
    redirect_to resource.campaign, notice: 'Pledge accepted.'
  end

  def reject
    message = params[:reject_message][:message]
    redirect_to fundraiser_pledges_path, notice: 'Pledge rejected.' if resource.reject!(message)
  end

  def add_reject_message
    @pledge = resource
    render 'pledges/form/reject_message'
  end

  def launch
    resource.launch!
    redirect_to resource, notice: 'Pledge was successfully confirmed.'
  end

  #Clicks
  def click
    if current_browser.present?
      if resource.active?
        click = (resource.unique_click_browsers.include?(current_browser) || resource.fully_subscribed?) ? resource.bonus_clicks.build(browser: current_browser) : resource.clicks.build(browser: current_browser)

        if click.save
          click.pusherize
          redirect_to resource.decorate.website_url 
        else
          redirect_to resource, alert: click.errors.messages
        end
      else
        redirect_to resource.decorate.website_url
      end
    else
      redirect_to resource, alert: 'There was an error when trying to count your click. Please try again.'
    end
  end

  #Increase
  def increase
    @pledge = resource
  end

  def set_increase
    update! do |success, failure|
      success.html do
        resource.increase! unless resource.changes.blank?
        redirect_to resource, notice: 'Pledge increased succesfully.'
      end
      failure.html do
        render 'increase'
      end
    end
  end

  def increase_request
    redirect_to resource, notice: 'Increase requested.' if resource.increase_request!
  end

  def permitted_params
    params.permit(
      pledge: [
        :name, :mission, :headline, :description, :amount_per_click,
        :total_amount, :show_coupons, :website_url, :terms, :campaign_id, :step, video_attributes: [:id, :url, :auto_show],
        picture_attributes: [
          :id, :banner, :avatar, :avatar_caption,
          :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h,
          :banner_crop_x, :banner_crop_y, :banner_crop_w, :banner_crop_h
        ],
        sweepstakes_attributes: [:id, :title, :description, :terms_conditions, :avatar, :winners_quantity,
        :claim_prize_instructions, :standard_terms, :_destroy]
      ],
      click: [:browser_plugins]
    )
  end

  protected

  def clear_cookies
    cookies.delete(:pledge_campaign) if cookies[:pledge_campaign].present?
    cookies.delete(:pledge_fundraiser) if cookies[:pledge_fundraiser].present?
  end

  def allow_only_sponsors
    unless current_sponsor.present?
      cookies[:pledge_campaign] = {value: params[:campaign], expires: 1.hour.from_now }
      cookies[:pledge_fundraiser] = {value: params[:fundraiser], expires: 1.hour.from_now }
      sign_out current_user if current_user.present?
      alert_message = params[:campaign].present? ? "To pledge this campaign first you have to register as a Sponsor." : "To pledge this fundraiser first you have to register as a Sponsor."
      redirect_to new_user_registration_path, alert: alert_message
    end
  end

  def block_fully_subscribed
    redirect_to increase_pledge_path(resource), alert: 'Pledge Fully Subscribed. Please increase pledge amount to reactivate this pledge.' if resource.fully_subscribed?
  end
end
