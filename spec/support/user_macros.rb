module UserMacros
  def login_user(user)
    visit new_user_session_path
    fill_in "user_email", :with => user.email
    fill_in "user_password", :with => "password"
    click_button("Sign in")
  end

  def set_ability(user)
    Ability.new(user)
  end
end