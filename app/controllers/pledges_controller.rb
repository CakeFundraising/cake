class PledgesController < InheritedResources::Base
  authorize_resource
  before_action :allow_only_sponsors, only: :new

  WIZARD_STEPS = [
    :your_pledge,
    :tell_your_story,
    :add_coupon,
    # :add_sweepstakes,
    :share
  ]

  def new
    if params[:campaign].present?
      @pledge = Pledge.new(campaign_id: params[:campaign])
      render 'new'
    else
      redirect_to search_campaigns_path, alert: 'Please review these campaigns to start a pledge.'
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

  def click
    if resource.have_donated?(request.remote_ip)
      redirect_to resource, alert:"You can contribute to any pledge just once!"
    else
      click = Click.new(request_ip: request.remote_ip, pledge: resource)
      
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
    update! do |success, failure|
      success.html do
        resource.notify_increase unless resource.previous_changes.blank?
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
    params.permit(pledge: [:mission, :headline, :description, :amount_per_click, :donation_type, 
      :total_amount, :show_coupons, :website_url, :terms, :campaign_id, :step, video_attributes: [:id, :url],
      picture_attributes: [:id, :banner, :avatar, :avatar_caption, :banner_caption, :avatar_cache, :banner_cache],
      coupons_attributes: [:id, :title, :expires_at, :promo_code, :description, :terms_conditions, :avatar, 
      :extra_donation_pledge, :unit_donation, :total_donation, :standard_terms, :_destroy, :qrcode, :avatar_cache, :qrcode_cache, merchandise_categories: [] ],
      sweepstakes_attributes: [:id, :title, :description, :terms_conditions, :avatar, :winners_quantity,
      :claim_prize_instructions, :standard_terms, :_destroy, :avatar_cache]
    ])
  end

  protected

  def allow_only_sponsors
    unless current_sponsor.present?
      cookies[:pledge_campaign] = params[:campaign]
      sign_out current_user if current_user.present?
      alert_message = params[:campaign].present? ? "To pledge this campaign first you have to register as a Sponsor." : "To pledge this fundraiser first you have to register as a Sponsor."
      redirect_to new_user_registration_path, alert: alert_message
    end
  end
end
