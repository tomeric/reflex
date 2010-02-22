module Reflex
  module Authlogic
    class CallbackFilter
      def initialize(app)
        @app = app
      end

      def call(env)
        # if :react_callback_method is available in the session and the requested URL's query
        # contains ReactOAuthSession, change the REQUEST_METHOD to :react_callback_method
        if env["rack.session"][:react_callback_method].present? && env["QUERY_STRING"] =~ /ReactOAuthSession/
          env["REQUEST_METHOD"] = env["rack.session"].delete(:react_callback_method).to_s.upcase
          
          if env["rack.session"][:react_callback_location].present?
            location = env["rack.session"].delete(:react_callback_location)
            
            env["REQUEST_URI"] = location
            env["PATH_INFO"]   = location.split('?').first
          end
        end
        
        @app.call(env)
      end      
    end
  end
end