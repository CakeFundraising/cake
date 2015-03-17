module Requestable
  extend ActiveSupport::Concern

  module ClassMethods
    def resend!(redirection_path, notice=nil)
      define_method(:resend) do
        path = redirection_path.respond_to?(:call) ? redirection_path.call : redirection_path
        redirect_to send(path), notice: (notice || 'Your item was resent.') if resource.resend!
      end
    end
  end
end