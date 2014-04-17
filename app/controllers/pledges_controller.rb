class PledgesController < InheritedResources::Base

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
        render action: :new
      end
    end
  end

  def update
    update! do |success, failure|
      success.html do
        redirect_to controller: :pledges, action: params[:pledge][:step], id: resource
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
    params.permit(pledge: [ :mission, :headline, :description, :amount_per_click, :donation_type, 
      :total_amount, :website_url, :terms, :campaign_id, :step, video_attributes: [:url],
      picture_attributes: [:banner, :avatar, :avatar_caption, :banner_caption, :avatar_cache, :banner_cache]
    ])
  end
end
