class PledgesController < InheritedResources::Base
  authorize_resource

  WIZARD_STEPS = [
    :your_pledge,
    :tell_your_story,
    :add_coupon,
    # :add_sweepstakes,
    :share
  ]

  def show
    @pledge = resource.decorate
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
    resource.notify_rejection if resource.rejected!
    redirect_to fundraiser_pending_pledges_path, notice: 'Pledge rejected.'
  end

  def permitted_params
    params.permit(pledge: [:mission, :headline, :description, :amount_per_click, :donation_type, 
      :total_amount, :website_url, :terms, :campaign_id, :step, video_attributes: [:id, :url],
      picture_attributes: [:id, :banner, :avatar, :avatar_caption, :banner_caption, :avatar_cache, :banner_cache],
      coupons_attributes: [:id, :title, :expires_at, :promo_code, :description, :terms_conditions, :avatar, 
      :extra_donation_pledge, :unit_donation, :total_donation, :standard_terms, :_destroy, :qrcode, :avatar_cache, :qrcode_cache],
      sweepstakes_attributes: [:id, :title, :description, :terms_conditions, :avatar, :winners_quantity,
      :claim_prize_instructions, :standard_terms, :_destroy, :avatar_cache]
    ])
  end
end
