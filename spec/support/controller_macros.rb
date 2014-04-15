module ControllerMacros
  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @fundraiser = FactoryGirl.create :fundraiser
      @user = FactoryGirl.create :fundraiser_user, fundraiser: @fundraiser
      sign_in @user
    end
  end
end