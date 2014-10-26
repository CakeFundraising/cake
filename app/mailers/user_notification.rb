class UserNotification < AsyncMailer
  default from: "no-reply@cakefundraising.com"

  def account_updated(user_id)
    user = find_user(user_id)

    @receiver = user.decorate
    @attributes_changed = user.previous_changes
    mail(to: @receiver.email, subject: 'Your account information has been modified.')
  end

  def fundraiser_profile_updated(fr_id, user_id)
    user = find_user(user_id)
    fr = find_fr(fr_id)

    @receiver = user.decorate
    @attributes_changed = fr.previous_changes
    mail(to: @receiver.email, subject: 'Your public profile has been modified.')
  end

  def sponsor_profile_updated(sp_id, user_id)
    user = find_user(user_id)
    sp = find_sp(sp_id)

    @receiver = user.decorate
    @attributes_changed = sp.previous_changes
    mail(to: @receiver.email, subject: 'Your public profile has been modified.')
  end

  protected

  def find_fr(id)
    Fundraiser.find(id)
  end

  def find_sp(id)
    Sponsor.find(id)
  end
end
