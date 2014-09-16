class PledgeNotification < ActionMailer::Base
  default from: "no-reply@cakefundraising.com"

  #Pledge Requests
  def new_pledge_request(pledge_request, message)
    @pr = pledge_request
    @receiver = @pr.sponsor.manager.decorate
    @sender = @pr.fundraiser.manager.decorate
    @message = message
    mail(to: @receiver.email, subject: 'You have a new pledge request.')          
  end

  def rejected_pledge_request(pledge_request, message)
    @pr = pledge_request
    @receiver = @pr.fundraiser.manager.decorate
    @sender = @pr.sponsor.manager.decorate
    @message = message
    mail(to: @receiver.email, subject: 'Your Pledge Request has been rejected.')
  end

  #Pledges
  def launch_pledge(pledge, user)
    @p = pledge
    @receiver = user.decorate
    @sender = @p.sponsor.manager.decorate
    mail(to: @receiver.email, subject: 'You have a new pledge offer.')
  end

  def accepted_pledge(pledge, user)
    @p = pledge
    @receiver = user.decorate
    @sender = @p.fundraiser.manager.decorate
    mail(to: @receiver.email, subject: 'Your Pledge has been accepted.')
  end

  def rejected_pledge(pledge, user, message)
    @p = pledge
    @message = message
    @receiver = user.decorate
    @sender = @p.fundraiser.manager.decorate
    mail(to: @receiver.email, subject: 'Your Pledge has been rejected.')
  end

  #clicks
  def fr_pledge_fully_subscribed(pledge, user)
    @p = pledge
    @receiver = user.decorate
    mail(to: @receiver.email, subject: "Your campaign's pledge has been 100% subscribed.")
  end

  def sp_pledge_fully_subscribed(pledge, user)
    @p = pledge
    @receiver = user.decorate
    mail(to: @receiver.email, subject: 'Your pledge has been 100% subscribed.')
  end

  #increase
  def pledge_increased(pledge, user)
    @p = pledge
    @changes = pledge.previous_changes
    @receiver = user.decorate
    mail(to: @receiver.email, subject: "Your campaign's pledge has been increased.")
  end

  def pledge_increase_request(pledge, user)
    @p = pledge
    @receiver = user.decorate
    mail(to: @receiver.email, subject: "Your pledge has a new increase request.")
  end
end
