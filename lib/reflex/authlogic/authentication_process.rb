module Reflex
  module Authlogic
    module AuthenticationProcess
      private

      def redirect_to_oauth_server(options = {})
        # Request the URL to redirect to
        result = Reflex::OAuthServer.token_request(react_provider)

        # Set the request method (POST) in the session, so our 
        # middleware can detect it and use it on the callback URL:
        reflex_controller.session[:react_callback_method]   = reflex_controller.request.method
        reflex_controller.session[:react_callback_location] = options[:callback_location]

        # Redirect the visitor to the given URL
        reflex_controller.redirect_to(result['redirectUrl'])
      end

      def react_provider
       reflex_controller.params && reflex_controller.params['react_provider'] 
      end

      def react_oauth_session
        reflex_controller.params && reflex_controller.params['ReactOAuthSession']
      end

      def redirecting_to_oauth_server?
        reflex_controller && authenticating_via_oauth_server? && !react_oauth_session
      end

      def authenticating_via_oauth_server?
        reflex_controller && (react_provider.present? || react_oauth_session.present?) # || did_not_allow_access
      end

      def reflex_controller
        self.is_a?(::Authlogic::Session::Base) ? controller : session_class.controller
      end    
    end
  end
end