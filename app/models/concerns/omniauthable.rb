module Omniauthable
  extend ActiveSupport::Concern

  module ClassMethods
    ### OmniAuth registration ###
    def find_user_from(auth)
      where(provider: auth.provider, uid: auth.uid).first
    end

    def new_with(auth, role, params)
      u = if params.blank? #only auth present
        new(full_name: auth.info.nickname, 
            email: auth.info.email,
            auth_token: auth.credentials.token,
            auth_secret: auth.credentials.secret,
            provider: auth.provider,
            uid: auth.uid)
      elsif auth.present? and params.present? #both present
        new(params.merge(
              auth_token: auth.credentials.token,
              auth_secret: auth.credentials.secret,
              provider: auth.provider,
              uid: auth.uid
            ))
      else #only params present
        new(params)
      end

      u.roles = [role] #Add role
      u
    end
  end
end