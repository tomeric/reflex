module Reflex
  class OAuthServer < Base
    class << self
      # Get all providers with API-keys configured
      def get_providers
        call!("OAuthServer.getProviders")
      end

      # Request a token. First step of the authentication process.
      def token_request(provider)
        call!("OAuthServer.tokenRequest", provider)
      end

      # Grant access to token. Second step of the authentication process.
      def token_access(params)
        call!("OAuthServer.tokenAccess", params)
      end

      # Identify the user. Stores the relation between the third party id
      # and the user_id. Third step of the authentication process.
      def token_set_user_id(user_id, oauth_session)
        call!("OAuthServer.tokenSetUserId", user_id, oauth_session)
      end

      # Return a list of providers that the user is connected to
      def user_get_providers(user_id)
        call!("OAuthServer.userGetProviders", user_id)
      end
    
      # Remove the connection between a user and a provider
      def user_remove_provider(user_id, provider)
        call!("OAuthServer.userRemoveProvider", user_id, provider)
      end

      # Returns a generic (same for all providers) list of profiledata
      def user_get_profile(user_id, provider)
        call!("OAuthServer.userGetProfile", user_id, provider)
      end

      # Returns a generic (same for all providers) list of profiledata
      # given a OAuthSession
      def session_get_profile(oauth_session)
        call!("OAuthServer.sessionGetProfile", oauth_session)
      end
    end
  end
end