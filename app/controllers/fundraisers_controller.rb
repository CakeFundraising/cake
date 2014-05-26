class FundraisersController < InheritedResources::Base
  respond_to :html

  def show
    @fundraiser = resource.decorate
  end

  def create
    @fundraiser = Fundraiser.new(*resource_params)
    @fundraiser.build_location(resource_params.first['location_attributes'])
    @fundraiser.manager = current_user

    create! do |success, failure|
      current_user.set_fundraiser(@fundraiser)
      session[:new_user] = nil if session[:new_user]

      success.html do
        redirect_to new_campaign_path, notice: 'Now you can start creating a new campaign!'  
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
        picture_attributes: [:id, :banner, :avatar, :avatar_caption, :banner_caption] 
      ],
      bank_account: [:name, :type, :email, :token, :tax_id]
    )
  end
end
