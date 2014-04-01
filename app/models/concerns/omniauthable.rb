module Omniauthable
  extend ActiveSupport::Concern

  module ClassMethods
    ### OmniAuth registration ###
    def find_user_from(auth)
      where(provider: auth.provider, uid: auth.uid).first
    end

    def new_user_with(auth)
      new(full_name: auth.info.nickname, 
          email: auth.info.email,
          auth_token: auth.credentials.token,
          auth_secret: auth.credentials.secret,
          provider: auth.provider,
          uid: auth.uid)
    end
  end
end