class PledgesController < InheritedResources::Base
  WIZARD_STEPS = [
    :your_pledge,
    :tell_your_story,
    :add_coupon,
    :add_sweepstakes,
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
    @pledge.coupons.build if @pledge.coupons.blank?
    render 'pledges/form/add_coupon'
  end

  def add_sweepstakes
    @pledge = resource
    render 'pledges/form/add_sweepstakes'
  end

  def share
    @pledge = resource
    render 'pledges/form/share'
  end

  def badge
    @pledge = resource.decorate
    render layout: false
    response.headers.except! 'X-Frame-Options'
  end

  def permitted_params
    params.permit(pledge: [:mission, :headline, :description, :amount_per_click, :donation_type, 
      :total_amount, :website_url, :terms, :campaign_id, :step, video_attributes: [:url],
      picture_attributes: [:banner, :avatar, :avatar_caption, :banner_caption, :avatar_cache, :banner_cache],
      coupons_attributes: [:title, :expires_at, :promo_code, :description, :terms_conditions, :avatar, 
      :extra_donation_pledge, :standard_terms, :_destroy, :qrcode, :avatar_cache, :qrcode_cache]
    ])
  end
end
