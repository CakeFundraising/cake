class PledgeNotification < AsyncMailer
  default from: "no-reply@cakecausemarketing.com"

  #Pledge Requests
  def new_pledge_request(pledge_request_id, message)
    @pr = find_pledge_request(pledge_request_id).decorate
    
    @receiver = @pr.sponsor.manager.decorate
    @requester = @pr.requester.decorate
    @campaign = @pr.campaign.decorate
    @message = message

    mail(to: @receiver.email, subject: 'You have a new pledge request.')          
  end

  def rejected_pledge_request(pledge_request_id, message)
    @pr = find_pledge_request(pledge_request_id).decorate

    @receiver = @pr.requester.manager.decorate
    @campaign = @pr.campaign.decorate
    @message = message

    mail(to: @receiver.email, subject: 'Your Pledge Request has been rejected.')
  end

  #Pledge Actions
  def launch_pledge(pledge_id, user_id)
    @p = find_pledge(pledge_id).decorate
    @cakester = @p.cakester

    @receiver = find_user(user_id).decorate
    @sender = @p.sponsor.manager.decorate
    
    mail(to: @receiver.email, subject: 'You have a new pledge offer.', template_path: 'mailers/pledge/fundraiser', template_name: 'launch_pledge')
  end

  def accepted_pledge(pledge_id, user_id)
    @p = find_pledge(pledge_id).decorate
    @receiver = find_user(user_id).decorate
    @sender = @p.fundraiser.manager.decorate

    mail(to: @receiver.email, subject: 'Your Pledge has been accepted.', template_path: "mailers/pledge/#{@receiver.roles.first}", template_name: 'accepted_pledge')
  end

  def rejected_pledge(pledge_id, user_id, message)
    @p = find_pledge(pledge_id).decorate
    @message = message
    @receiver = find_user(user_id).decorate
    @sender = @p.fundraiser.manager.decorate

    mail(to: @receiver.email, subject: 'Your Pledge has been rejected.', template_path: "mailers/pledge/#{@receiver.roles.first}", template_name: 'rejected_pledge')
  end

  #Pledge Fully Subscribed
  def fr_pledge_fully_subscribed(pledge_id, user_id)
    @p = find_pledge(pledge_id).decorate
    @receiver = find_user(user_id).decorate
    mail(to: @receiver.email, subject: "Your campaign's pledge has been 100% subscribed.", template_path: 'mailers/pledge/fundraiser', template_name: 'pledge_fully_subscribed')
  end

  def sp_pledge_fully_subscribed(pledge_id, user_id)
    @p = find_pledge(pledge_id).decorate
    @receiver = find_user(user_id).decorate
    mail(to: @receiver.email, subject: 'Your pledge has been 100% subscribed.', template_path: 'mailers/pledge/sponsor', template_name: 'pledge_fully_subscribed')
  end

  #Pledge Increase
  def pledge_increased(pledge_id, user_id)
    @p = find_pledge(pledge_id).decorate
    @changes = @p.previous_changes
    @receiver = find_user(user_id).decorate
    mail(to: @receiver.email, subject: "Your campaign's pledge has been increased.", template_path: 'mailers/pledge/fundraiser', template_name: 'pledge_increased')
  end

  def pledge_increase_request(pledge_id, user_id)
    @p = find_pledge(pledge_id).decorate
    @receiver = find_user(user_id).decorate
    mail(to: @receiver.email, subject: "Your pledge has a new increase request.", template_path: 'mailers/pledge/sponsor', template_name: 'pledge_increase_request')
  end

  #Quick Pledges
  def qp_created(qp_id)
    @qp = find_pledge(qp_id).decorate 
    sp_email = @qp.sponsor.email
    @fr = @qp.fundraiser.decorate
    @campaign = @qp.campaign
    mail(to: sp_email, cc: @fr.manager.email, subject: 'You have a new Cake pledge!')
  end

  protected

  def find_pledge_request(id)
    PledgeRequest.find(id)
  end

  def find_pledge(id)
    Pledge.find(id)
  end
end
