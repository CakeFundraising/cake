class UserNotification < ActionMailer::Base
  default from: "no-reply@cakefundraising.com"

  def account_updated(user)
    @receiver = user
    @attributes_changed = user.previous_changes
    mail(to: @receiver.email, subject: 'Your account information has been modified.')
  end

  def profile_updated(user_role)
    @receiver = user_role.manager
    @attributes_changed = user_role.previous_changes
    mail(to: @receiver.email, subject: 'Your public profile has been modified.')
  end
end
