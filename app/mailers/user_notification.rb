class UserNotification < ActionMailer::Base
  default from: "no-reply@cakefundraising.com"

  def account_updated(user)
    @receiver = user
    @attributes_changed = user.previous_changes
    mail(to: @receiver.email, subject: 'Your account information has been modified.')
  end

  def fundraiser_profile_updated(fr, user)
    @receiver = user.decorate
    @attributes_changed = fr.previous_changes
    mail(to: @receiver.email, subject: 'Your public profile has been modified.')
  end
end
