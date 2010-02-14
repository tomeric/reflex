module Reflex
  module Authlogic
    module Session
      def self.included(klass)
        klass.class_eval do
          validate :validate_by_reflex, :if => :authenticating_via_oauth_server?
        end
      end

      # Clears out the block if we are authenticating via react,
      # so that we can redirect without a DoubleRender error.
      def save(&block)
        block = nil if redirecting_to_oauth_server?
        super(&block)        
      end

      private

      def validate_by_reflex
        if redirecting_to_oauth_server?
          redirect_to_oauth_server
    
        elsif react_oauth_session
          authenticate_oauth_session
      
        else
          # User did not grant access. Deal with it!
          errors.add(:reflex, :invalid)
        end
      end
  
      def redirect_to_oauth_server
        # Request the URL to redirect to
        result = Reflex::OAuthServer.token_request(react_provider)

        # Set the request method (POST) in the session, so our 
        # middleware can detect it and use it on the callback URL:
        controller.session[:react_callback_method] = controller.request.method

        # Redirect the visitor to the given URL
        controller.redirect_to(result['redirectUrl'])
      end

      def authenticate_oauth_session(allow_retry = true)
        # Request the React Session
        oauth_session  = Reflex::OAuthServer.token_access(controller.params)
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
          self.attempted_record = klass.create_for_react(react_profile) 
          
          if !attempted_record.new_record?
            react_user_id = attempted_record.id # react_user_id
      
            # Set the user id on react's side:
            Reflex::OAuthServer.token_set_user_id(react_user_id, react_oauth_session)
          else
            # Something must have gone wrong
            errors.add_to_base(:react_auth_failed) 
            
            return false
          end
          
          true
        end
      end
  
      def react_provider
       controller.params && controller.params['react_provider'] 
      end

      def react_oauth_session
        controller.params && controller.params['ReactOAuthSession']
      end

      def redirecting_to_oauth_server?
        authenticating_via_oauth_server? && !react_oauth_session
      end

      def authenticating_via_oauth_server?
        react_provider.present? || react_oauth_session.present? # || did_not_allow_access
      end
    end
  end
end

Authlogic::Session::Base.send(:include, Reflex::Authlogic::Session)