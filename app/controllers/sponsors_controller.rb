class SponsorsController < InheritedResources::Base
  before_action :check_if_account_created, only: [:new, :create]
  before_action :allow_sp_only, only: :credit_card
  before_action :require_password, only: :credit_card

  def show
    @sponsor = resource.decorate
    @active_pledges = @sponsor.pledges.active  
    @past_pledges = @sponsor.pledges.past
    @fundraisers = FundraiserDecorator.decorate_collection @sponsor.fundraisers
  end

  def create
    @sponsor = Sponsor.new(*resource_params)
    @sponsor.build_location(resource_params.first['location_attributes'])
    @sponsor.manager = current_user

    create! do |success, failure|
      success.html do
        current_user.set_role(@sponsor)

        if cookies[:pledge_campaign].present?
          redirect_to new_pledge_path(campaign: cookies[:pledge_campaign])
        elsif cookies[:pledge_fundraiser].present?
          redirect_to new_pledge_path(fundraiser: cookies[:pledge_fundraiser])
        else
          redirect_to sponsor_home_path, notice: 'Now you can start using Cake!'
        end
      end
    end
  end

  def update
    update! do |success, failure|
      success.html do
        send_notification
        redirect_to resource, notice: 'Profile saved.'
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
      if @stripe_account.store_cc(@credit_card)
        session.delete(:password_confirmed)
        redirect_to sponsor_home_path, notice: 'Your credit card information has been saved.' 
      end
    else
      render 'credit_cards/new', alert: 'You credit card information is incorrect.'
    end
  end

  def permitted_params
    params.permit(
      sponsor: [
        :name, :mission, :manager_name, :manager_title, :manager_email, :manager_phone, 
        :customer_demographics, :phone, :email, :website,
        :email_subscribers, :facebook_subscribers, :twitter_subscribers, :pinterest_subscribers,
        cause_requirements: [], scopes: [], causes: [],
        location_attributes: [:address, :city, :zip_code, :state_code, :country_code],
        picture_attributes: [
          :id, :banner, :avatar, :avatar_caption,
          :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h,
          :banner_crop_x, :banner_crop_y, :banner_crop_w, :banner_crop_h
        ]
      ],
      credit_card: [:token]
    )
  end

  private

  def allow_sp_only
    redirect_to root_path, alert:"You don't have permissions to see this page" if current_user.nil? or current_sponsor != resource
  end

  def require_password
    redirect_to confirm_path(url: credit_card_sponsor_path(current_sponsor)) unless session[:password_confirmed]
  end

  def send_notification
    resource.notify_update
  end

  def check_if_account_created
    redirect_to root_path, alert:'Please sign out and create a new account if you want to create a new Sponsor account.' if current_user.nil? or current_sponsor.present?
  end
end
