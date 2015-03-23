module BankAccountController
  extend ActiveSupport::Concern

  included do
    before_action :require_password, only: :bank_account
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
        redirect_to after_ba_set_path, notice: 'Your bank account information has been saved.' 
      end
    else
      render 'bank_accounts/new', alert: 'You bank account information is incorrect.'
    end
  end

  protected

  def require_password
    redirect_to confirm_path(url: ba_path) unless session[:password_confirmed]
  end

end