module UserHelper
  def login_user(user)
    visit new_user_session_path
    fill_in "user_email", :with => user.email
    fill_in "user_password", :with => user.password
    click_button("Sign in")
  end

  def register_sponsor
    fill_in('Full name', with: 'Sponsor User')
    fill_in('Email', with: 'sponsor_user@example.com')
    fill_in('Password', with: 'password')
    fill_in('Password confirmation', with: 'password')
    click_button "Sign up"
  end
end

World(UserHelper)