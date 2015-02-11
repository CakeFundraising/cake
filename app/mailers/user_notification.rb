class UserNotification < AsyncMailer
  default from: "no-reply@cakecausemarketing.com"

  def account_updated(user_id)
    user = find_user(user_id)

    @receiver = user.decorate
    @attributes_changed = user.previous_changes
    mail(to: @receiver.email, subject: 'Your account information has been modified.')
  end

  def new_fr(fr_id)
    @fr = find_fr(fr_id)
    @manager = @fr.manager

    mail(to: 'newusers@cakefundraising.com', subject: 'A new Fundraiser has signed up!')
  end

  def new_sp(sp_id)
    @sp = find_sp(sp_id)
    @manager = @sp.manager

    mail(to: 'newusers@cakefundraising.com', subject: 'A new Sponsor has signed up!')
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

  def fr_partnership_request(fr_id, sp_id, message)
    @fr = find_fr(fr_id)
    @sp = find_sp(sp_id).decorate
    @message = message
    
    mail(to: @fr.manager.email, subject: 'You have a new Partnership Request from an interesting Sponsor.')
  end

  protected

  def find_fr(id)
    Fundraiser.find(id)
  end

  def find_sp(id)
    Sponsor.find(id)
  end
end
