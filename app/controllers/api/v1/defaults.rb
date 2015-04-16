module API
  module V1
    module Defaults
      extend ActiveSupport::Concern
      included do 
        helpers Doorkeeper::Grape::Helpers
        formatter :json, Grape::Formatter::Jbuilder

        before do
          doorkeeper_authorize!
          header['Access-Control-Allow-Origin'] = '*'
          header['Access-Control-Request-Method'] = '*'
        end

        helpers do
          def current_token
            doorkeeper_token
          end
          
          def current_user
            resource_owner
          end

          def current_scopes
            current_token.scopes
          end
        end
      
      end
    end
  end
end