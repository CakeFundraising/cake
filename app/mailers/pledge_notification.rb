class PledgeNotification < ActionMailer::Base
  default from: "no-reply@cakefundraising.com"

  def rejected_pledge_request(pledge_request)
    @pr = pledge_request
    @receiver = @pr.fundraiser.manager.decorate
    @sender = @pr.sponsor.manager.decorate
    mail(to: @receiver.email, subject: 'Your Pledge Request has been rejected.')
  end
end
