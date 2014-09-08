class PledgesController < InheritedResources::Base
  authorize_resource
  before_action :allow_only_sponsors, :clear_cookies, only: :new

  WIZARD_STEPS = [
    :your_pledge,
    :tell_your_story,
    :add_coupon,
    # :add_sweepstakes,
    :share
  ]

  include PastResource

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
      redirect_to search_campaigns_path, alert: 'Please select one of these campaigns to start a pledge.'
    end
  end

  def show
    @pledge = resource.decorate
    redirect_if_turbolinks_to(@pledge)
  end

  def create
    @pledge = current_sponsor.pledges.build(*resource_params)

    create! do |success, failure|
      success.html do
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
    @pledge.coupons.build unless @pledge.coupons.any?
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
    redirect_to fundraiser_pending_pledges_path, notice: 'Pledge rejected.' if resource.reject!(message)
  end

  def add_reject_message
    @pledge = resource
    render 'pledges/form/reject_message'
  end

  def launch
    resource.launch!
    redirect_to resource, notice: 'Pledge was successfully launched.'
  end

  #Clicks
  def solicit_click
    @plugins = permitted_params[:click][:browser_plugins] if permitted_params[:click].present?
    @pledge = resource
    @clicked_before = @pledge.have_donated?(request, @plugins)

    render partial:'clicks/modal_content'
  end

  def click
    plugins = permitted_params[:click][:browser_plugins] if permitted_params[:click].present?

    if resource.have_donated?(request, plugins)
      redirect_to resource, alert:"You can contribute to any pledge just once!"
    else
      click = Click.build_with(resource, request, plugins)
      
      if click.save
        redirect_to resource.website_url 
      else
        redirect_to resource, alert: click.errors.messages
      end
    end
  end

  #Increase
  def increase
    @pledge = resource
  end

  def set_increase
    old_amount_per_click_cents = resource.amount_per_click_cents
    old_total_amount_cents = resource.total_amount_cents

    respond_to do |format|
      if resource.update(permitted_params[:pledge])
        #Force ammounts save
        new_amount_per_click_cents = (permitted_params[:pledge][:amount_per_click].to_f*100).to_i
        new_total_amount_cents = (permitted_params[:pledge][:total_amount].to_f*100).to_i
        resource.force_save_amounts(old_amount_per_click_cents, old_total_amount_cents, new_amount_per_click_cents, new_total_amount_cents)

        format.html do
          resource.increase! unless resource.changes.blank?
          redirect_to resource, notice: 'Pledge increased succesfully.'
        end
        format.json { head :no_content }
      else
        format.html do
          render 'increase'
        end
        format.json { render json: resource.errors, status: :unprocessable_entity }
      end
    end
  end

  def increase_request
    redirect_to resource, notice: 'Increase requested.' if resource.increase_request!
  end

  def permitted_params
    params.permit(pledge: [:name, :mission, :headline, :description, :amount_per_click, :donation_type, 
      :total_amount, :show_coupons, :website_url, :terms, :campaign_id, :step, video_attributes: [:id, :url],
      picture_attributes: [:id, :banner, :avatar, :avatar_caption, :banner_caption, :avatar_cache, :banner_cache],
      coupons_attributes: [:id, :title, :expires_at, :promo_code, :description, :terms_conditions, :avatar, 
      :extra_donation_pledge, :unit_donation, :total_donation, :standard_terms, :_destroy, :qrcode, :avatar_cache, :qrcode_cache, merchandise_categories: [],
      picture_attributes: [:id, :banner, :avatar, :avatar_caption, :banner_caption, :avatar_cache, :banner_cache] ],
      sweepstakes_attributes: [:id, :title, :description, :terms_conditions, :avatar, :winners_quantity,
      :claim_prize_instructions, :standard_terms, :_destroy, :avatar_cache]
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
      cookies[:pledge_campaign] = params[:campaign]
      cookies[:pledge_fundraiser] = params[:fundraiser]
      sign_out current_user if current_user.present?
      alert_message = params[:campaign].present? ? "To pledge this campaign first you have to register as a Sponsor." : "To pledge this fundraiser first you have to register as a Sponsor."
      redirect_to new_user_registration_path, alert: alert_message
    end
  end
end
