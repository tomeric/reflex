require 'reflex/authlogic/authentication_process'

module Reflex
  module Authlogic
    module Connectable        
      def self.included(base)
        base.send(:extend, ClassMethods)
        base.send(:include, InstanceMethods)
        
        base.validate :authenticate_oauth_session,
                      :if => lambda { |account| !account.new_record? && account.send(:authenticating_via_oauth_server?) }
      end
      
      module ClassMethods
      end
      
      module InstanceMethods
        include Reflex::Authlogic::AuthenticationProcess

        def save(perform_validation = true, &block)
          if perform_validation && block_given? && connecting_to_provider?
            # Save attributes in session so we can use them again after authentication
            reflex_controller.session[:authlogic_reflex_attributes] = attributes.reject!{|k, v| v.blank?}
            
            # Redirect to the OAuth Server, but set a callback location so we return here
            redirect_to_oauth_server(:callback_location => reflex_controller.request.path)
          
            return false 
          end               

          result = super

          yield(result) if block_given?
          result    
        end

        private
        
        def authenticating_via_oauth_server?
          super
        end        
      
        def connect_to_provider!
          if redirecting_to_oauth_server?
            redirect_to_oauth_server

          elsif react_oauth_session
            authenticate_oauth_session

          else
            # User did not grant access. Deal with it!
            errors.add(:reflex, :invalid)
          end              
        end
            
        def authenticate_oauth_session(allow_retry = true)
          # Request the React Session
          oauth_session  = Reflex::OAuthServer.token_access(reflex_controller.params)
          react_provider = oauth_session['connectedWithProvider']
          react_user_id  = oauth_session['applicationUserId']

          if react_user_id
            # applicationUserId is not longer valid, so remove it's provider remotely:
            Reflex::OAuthServer.user_remove_provider(react_user_id, react_provider)
          end
          
          # Create a new connection of this provider:
          connection = reflex_connections.create(:provider => react_provider)
          
          # Set the user id on react's side:
          Reflex::OAuthServer.token_set_user_id(connection.uuid, react_oauth_session)
          
          # Set the attributes that were set pre redirection
          if session_attributes = reflex_controller.session.delete(:authlogic_reflex_attributes)
            self.attributes = session_attributes
          end
          
          true
        end

        def connecting_to_provider?
          !new_record? && react_provider
        end

        def saving_for_react?
          connecting_to_provider? || super
        end
      end
    end
  end
end