module UserHelper
  include Devise::TestHelpers

  def login_user(user)
    visit new_user_session_path
    fill_in "user_email", :with => user.email
    fill_in "user_password", :with => "password"
    click_button("Sign in")
  end

  def register_sponsor
    fill_in('Full name', with: 'Sponsor User')
    fill_in('Email', with: 'sponsor_user@example.com')
    find('input#user_password').set('password')
    fill_in('Password confirmation', with: 'password')
    click_button "Sign up"
    confirm_user
  end

  def register_fundraiser
    fill_in('Full name', with: 'FR User')
    fill_in('Email', with: 'fr_user@example.com')
    find('input#user_password').set('password')
    fill_in('Password confirmation', with: 'password')
    click_button "Sign up"
    confirm_user
  end

  def confirm_user
    @user = User.last
    @user.confirm!
  end

  def sign_out_user
    page.driver.submit :delete, destroy_user_session_path, {}
  end
end

World(UserHelper)