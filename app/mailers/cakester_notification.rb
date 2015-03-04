class CakesterNotification < AsyncMailer
  default from: "no-reply@cakecausemarketing.com"

  def new_cakester_request(cakester_request_id, user_id)
    @receiver = find_user(user_id)
    @cakester_request = find_cakester_request(cakester_request_id)
    mail(to: @receiver.email, subject: 'New campaign request in Cake.')
  end

  def accepted_cakester_request(cakester_request_id, user_id)
    @receiver = find_user(user_id)
    @cakester_request = find_cakester_request(cakester_request_id)
    mail(to: @receiver.email, subject: 'Cakester request accepted!')
  end

  def rejected_cakester_request(cakester_request_id, user_id, message)
    @receiver = find_user(user_id)
    @cakester_request = find_cakester_request(cakester_request_id)
    @message = message
    mail(to: @receiver.email, subject: 'Cakester request rejected.')
  end

  private

  def find_cakester_request(id)
    CakesterRequest.find(id)
  end
end