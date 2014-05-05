class PledgeNotification < ActionMailer::Base
  default from: "no-reply@cakefundraising.com"

  #Pledge Requests
  def new_pledge_request(pledge_request)
    @pr = pledge_request
    @receiver = @pr.sponsor.manager.decorate
    @sender = @pr.fundraiser.manager.decorate
    mail(to: @receiver.email, subject: 'You have a new pledge request.')          
  end

  def rejected_pledge_request(pledge_request)
    @pr = pledge_request
    @receiver = @pr.fundraiser.manager.decorate
    @sender = @pr.sponsor.manager.decorate
    mail(to: @receiver.email, subject: 'Your Pledge Request has been rejected.')
  end

  #Pledges
  def launch_pledge(pledge, user)
    @p = pledge
    @receiver = user.decorate
    @sender = @p.sponsor.manager.decorate
    mail(to: @receiver.email, subject: 'You have a new pledge offer.')
  end

  def accepted_pledge(pledge)
    @p = pledge
    @receiver = @p.sponsor.manager.decorate
    @sender = @p.fundraiser.manager.decorate
    mail(to: @receiver.email, subject: 'Your Pledge has been accepted.')
  end

  def rejected_pledge(pledge)
    @p = pledge
    @receiver = @p.sponsor.manager.decorate
    @sender = @p.fundraiser.manager.decorate
    mail(to: @receiver.email, subject: 'Your Pledge has been rejected.')
  end
end
