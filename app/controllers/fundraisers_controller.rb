class FundraisersController < InheritedResources::Base
  before_action :check_if_account_created, only: [:new, :create]

  def show
    @fundraiser = resource.decorate
    @active_campaigns = @fundraiser.campaigns.active.decorate
    @past_campaigns = @fundraiser.campaigns.past.decorate
    @top_sponsors = SponsorDecorator.decorate_collection @fundraiser.sponsors.first(5)

    redirect_if_turbolinks_to(@fundraiser)
  end

  def create
    @fundraiser = Fundraiser.new(*resource_params)
    @fundraiser.build_location(resource_params.first['location_attributes'])
    @fundraiser.manager = current_user

    create! do |success, failure|
      success.html do
        current_user.set_fundraiser(@fundraiser)
        redirect_to new_campaign_path, notice: 'Now you can start creating a new campaign!'  
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

  def bank_account
    @bank_account = BankAccount.new
    render 'bank_accounts/new'
  end

  def set_bank_account
    @stripe_account = resource.stripe_account
    @bank_account = BankAccount.new(permitted_params[:bank_account])

    if @bank_account.valid?
      redirect_to fundraiser_home_path, notice: 'You have connected your Stripe account successfully.' if @stripe_account.create_stripe_recipient(@bank_account)
    else
      render 'bank_accounts/new', alert: 'You bank account information is incorrect.'
    end
  end

  def permitted_params
    params.permit(
      fundraiser: [
        :name, :mission, :manager_title, :supporter_demographics, 
        :manager_email, :min_pledge, :min_click_donation, :donations_kind, 
        :unsolicited_pledges, :manager_name, :manager_website, :manager_phone, 
        :tax_exempt, :phone, :email, :website, causes: [],
        location_attributes: [:address, :city, :zip_code, :state_code, :country_code],
        picture_attributes: [
          :id, :banner, :avatar, :avatar_caption, :banner_cache, :avatar_cache,
          :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h,
          :banner_crop_x, :banner_crop_y, :banner_crop_w, :banner_crop_h
        ] 
      ],
      bank_account: [:name, :type, :email, :token, :tax_id]
    )
  end

  private

  def send_notification
    resource.notify_update
  end

  def check_if_account_created
    redirect_to root_path, alert:'Please sign out and create a new account if you want to create a new Fundraiser account.' if current_user.nil? or current_fundraiser.present?
  end
end
