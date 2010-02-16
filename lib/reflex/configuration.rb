require 'singleton'
require 'uri'

module Reflex
  class Configuration
    include ::Singleton

    attr_accessor :key, :secret, :endpoint
    
    def uri
      @uri = URI.parse(endpoint) if @uri.nil? || @uri.to_s != endpoint
      @uri
    end
    
    def hostname
      uri.host
    end
    
    def path
      uri.path
    end
    
    def port
      uri.port || 80
    end
  end
  
  def self.configure(options = {})
    validate_valid_options!(options, :key, :secret, :endpoint)
    
    authorization = Configuration.instance
    options.each do |key, value|
      authorization.send(:"#{key}=", value)
    end
    
    authorization
  end
end