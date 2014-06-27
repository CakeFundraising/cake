class SponsorsController < InheritedResources::Base
  def show
    @sponsor = resource.decorate
    @active_pledges = @sponsor.pledges.active  
    @past_pledges = @sponsor.pledges.past
    @accepted_pledges = @sponsor.accepted_pledges

    reload_page_if_turbolinks_to(@sponsor)
  end

  def create
    @sponsor = Sponsor.new(*resource_params)
    @sponsor.build_location(resource_params.first['location_attributes'])
    @sponsor.manager = current_user

    create! do |success, failure|
      current_user.set_sponsor(@sponsor)
      session[:new_user] = nil if session[:new_user]

      success.html do
        # redirect_to new_campaign_path, notice: 'Now you can start creating a new campaign!'  
        redirect_to root_path, notice: 'Now you can start using CakeFundraising!'  
      end
    end
  end

  def credit_card
    @credit_card = CreditCard.new
    render 'credit_cards/new'
  end

  def set_credit_card
    @stripe_account = resource.stripe_account
    @credit_card = CreditCard.new(permitted_params[:credit_card])

    if @credit_card.valid?
      redirect_to sponsor_home_path, notice: 'Your credit card information has been saved.' if @stripe_account.create_stripe_customer(@credit_card)
    else
      render 'credit_cards/new', alert: 'You credit card information is incorrect.'
    end
  end

  def permitted_params
    params.permit(
      sponsor: [
        :name, :mission, :manager_name, :manager_title, :manager_email, :manager_phone, 
        :customer_demographics, :phone, :email, :website,
        cause_requirements: [], scopes: [], causes: [],
        location_attributes: [:address, :city, :zip_code, :state_code, :country_code],
        picture_attributes: [:id, :banner, :avatar, :avatar_caption, :banner_caption, :avatar_cache, :banner_cache] 
      ],
      credit_card: [:token]
    )
  end
end
