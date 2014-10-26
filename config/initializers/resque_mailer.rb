Resque::Mailer.excluded_environments = [:test, :cucumber]

class AsyncMailer < ActionMailer::Base
  include Resque::Mailer

  protected

  def find_user(id)
    User.find(id)
  end
end