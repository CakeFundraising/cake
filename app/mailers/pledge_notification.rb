class PledgeNotification < ActionMailer::Base
  default from: "no-reply@cakefundraising.com"

  #Pledge Requests
  def rejected_pledge_request(pledge_request)
    @pr = pledge_request
    @receiver = @pr.fundraiser.manager.decorate
    @sender = @pr.sponsor.manager.decorate
    mail(to: @receiver.email, subject: 'Your Pledge Request has been rejected.')
  end

  #Pledges
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
