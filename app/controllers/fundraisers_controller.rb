 class FundraisersController < InheritedResources::Base
  before_action :check_if_account_created, only: [:new, :create]
  before_action :allow_fr_only, only: :bank_account
  before_action :require_password, only: :bank_account
  before_action :require_sp, only: :request_partnership

  include ExtraClickController

  def show
    @fundraiser = resource.decorate
    @active_campaigns = @fundraiser.campaigns.active.decorate
    @past_campaigns = @fundraiser.campaigns.past.decorate
    @top_sponsors = SponsorDecorator.decorate_collection @fundraiser.sponsors.first(5)
  end

  def create
    @fundraiser = Fundraiser.new(*resource_params)
    @fundraiser.build_location(resource_params.first['location_attributes'])
    @fundraiser.manager = current_user

    create! do |success, failure|
      success.html do
        current_user.set_fundraiser(@fundraiser)
        after_create_redirect
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

  #Bank Accounts
  def bank_account
    @bank_account = BankAccount.new
    render 'bank_accounts/new'
  end

  def set_bank_account
    @stripe_account = resource.stripe_account
    @bank_account = BankAccount.new(permitted_params[:bank_account])

    if @bank_account.valid?
      if @stripe_account.store_ba(@bank_account)
        session.delete(:password_confirmed)
        redirect_to fundraiser_home_path, notice: 'Your bank account information has been saved.' 
      end
    else
      render 'bank_accounts/new', alert: 'You bank account information is incorrect.'
    end
  end

  #Request Partnership
  def request_partnership
    @fr = resource.decorate
  end

  def send_partnership
    @message = params[:partnership][:message]
    @fr = resource.decorate
    @sp = current_sponsor.decorate

    redirect_to root_path, notice: "We've sent your message to #{@fr}!" if UserNotification.fr_partnership_request(@fr.id, @sp.id, @message).deliver
  end

  def click
    campaign = Campaign.find_by_id(params[:campaign_id])
    extra_click(campaign.url, campaign)
  end

  def permitted_params
    params.permit(
      fundraiser: [
        :name, :mission, :manager_title, :supporter_demographics, 
        :manager_email, :min_pledge, :min_click_donation, :donations_kind, 
        :unsolicited_pledges, :manager_name, :manager_website, :manager_phone, 
        :email_subscribers, :facebook_subscribers, :twitter_subscribers, :pinterest_subscribers,
        :tax_exempt, :phone, :email, :website, causes: [],
        location_attributes: [:address, :city, :zip_code, :state_code, :country_code],
        picture_attributes: [
          :id, :banner, :avatar, :avatar_caption,
          :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h,
          :banner_crop_x, :banner_crop_y, :banner_crop_w, :banner_crop_h
        ] 
      ],
      bank_account: [:name, :type, :email, :token, :tax_id]
    )
  end

  private

  def after_create_redirect
    if cookies[:redirect_to].present?
      redirect_to "#{cookies[:redirect_to]}&cat=#{Doorkeeper::AccessToken.create!(application_id: Doorkeeper::Application.last.id, resource_owner_id: current_user.id, expires_in: 2.hours).token}"
      cookies.delete(:redirect_to)
    else
      redirect_to fundraiser_home_path, notice: 'Now you can start creating a new campaign!'
    end
  end

  def allow_fr_only
    redirect_to root_path, alert:"You don't have permissions to see this page" if current_user.nil? or current_fundraiser != resource
  end

  def require_sp
    unless current_sponsor.present?
      sign_out current_user if current_user.present?
      redirect_to new_user_registration_path, alert: "In order to request partnership to this Fundraiser you have first to register as a Sponsor."
    end
  end

  def require_password
    redirect_to confirm_path(url: bank_account_fundraiser_path(current_fundraiser)) unless session[:password_confirmed]
  end

  def send_notification
    resource.notify_update
  end

  def check_if_account_created
    redirect_to root_path, alert:'Please sign out and create a new account if you want to create a new Fundraiser account.' if current_user.nil? or current_fundraiser.present?
  end
end
