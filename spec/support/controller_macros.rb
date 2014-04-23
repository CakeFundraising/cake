module ControllerMacros
  def login_fundraiser
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @fundraiser = FactoryGirl.create :fundraiser
      @user = FactoryGirl.create :fundraiser_user, fundraiser: @fundraiser
      sign_in @user
    end
  end

  def login_sponsor
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @sponsor = FactoryGirl.create :sponsor
      @user = FactoryGirl.create :sponsor_user, sponsor: @sponsor
      sign_in @user
    end
  end
end