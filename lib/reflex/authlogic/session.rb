require 'reflex/authlogic/authentication_process'
  
module Reflex
  module Authlogic
    module Session
      include Reflex::Authlogic::AuthenticationProcess
      
      def self.included(base)
        base.validate :validate_by_reflex!, :if => :authenticating_via_oauth_server?
        
        base.send(:extend, ClassMethods)
        base.send(:include, InstanceMethods)
      end
      
      module ClassMethods
      end

      module InstanceMethods
        # Clears out the block if we are authenticating via react,
        # so that we can redirect without a DoubleRender error.
        def save(&block)
          block = nil if redirecting_to_oauth_server?
          super(&block)        
        end

        private

        def authenticate_oauth_session(allow_retry = true)
          # Request the React Session
          oauth_session  = Reflex::OAuthServer.token_access(reflex_controller.params)
          react_provider = oauth_session['connectedWithProvider']
          react_user_id  = oauth_session['applicationUserId']

          if react_user_id
            # User is known on React's side, so find it:
            self.attempted_record = klass.send(:find_by_react_user_id, react_user_id)

            unless attempted_record
              # applicationUserId is not longer valid, so remove it's provider remotely:
              Reflex::OAuthServer.user_remove_provider(react_user_id, react_provider)
        
              # Retry authorization can be retried:
              errors.add_to_base(:react_auth_retry)
            end
    
          else
            # User is not yet known on React's side, so create it:
            react_profile = Reflex::OAuthServer.session_get_profile(react_oauth_session)
      
            # Create a user record with a connection to this provider
            self.attempted_record, connection = klass.create_for_react(react_provider, react_profile) 
      
            if !attempted_record.new_record?
              # Set the user id on react's side:
              Reflex::OAuthServer.token_set_user_id(connection.uuid, react_oauth_session)
            else
              # Something must have gone wrong
              errors.add_to_base(:react_auth_failed) 
        
              return false
            end
      
            true
          end
        end

        def validate_by_reflex!
          if redirecting_to_oauth_server?
            redirect_to_oauth_server
    
          elsif react_oauth_session
            authenticate_oauth_session
      
          else
            # User did not grant access. Deal with it!
            errors.add(:reflex, :invalid)
          end
        end
      end
    end
  end
end

Authlogic::Session::Base.send(:include, Reflex::Authlogic::Session)