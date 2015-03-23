class CakesterNotification < AsyncMailer
  default from: "no-reply@cakecausemarketing.com"

  def new_cakester_request(cakester_request_id, user_id)
    @receiver = find_user(user_id).decorate
    @cakester_request = find_cakester_request(cakester_request_id)
    @fundraiser = @cakester_request.fundraiser.decorate

    mail(to: @receiver.email, cc: @fundraiser.manager.email, subject: 'New campaign request in Cake.')
  end

  def accepted_cakester_request(cakester_request_id, user_id)
    @receiver = find_user(user_id).decorate
    @cakester_request = find_cakester_request(cakester_request_id)
    mail(to: @receiver.email, subject: 'Cakester request accepted!')
  end

  def rejected_cakester_request(cakester_request_id, user_id, message)
    @receiver = find_user(user_id).decorate
    @cakester_request = find_cakester_request(cakester_request_id)
    @message = message
    mail(to: @receiver.email, subject: 'Cakester request rejected.')
  end

  def terminated_cakester_request(campaign_id, user_id, terminated_by_id, message)
    @receiver = find_user(user_id).decorate
    @campaign = find_campaign(campaign_id)
    @message = message

    # I couldn't resist..
    terminator_user = find_user(terminated_by_id) 
    @terminator = (terminator_user.try(:fundraiser) || terminator_user.try(:cakester) ).decorate

    mail(to: @receiver.email, subject: "Cakester Partnership Terminated by #{@terminator}.")
  end

  private

  def find_cakester_request(id)
    CakesterRequest.find(id).decorate
  end

  def find_campaign(id)
    Campaign.find(id).decorate
  end
end