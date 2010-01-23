require 'singleton'
require 'uri'

module Reflex
  class Configuration
    include ::Singleton

    attr_accessor :username, :password, :url
    
    def uri
      @uri = URI.parse(url) if @uri.nil? || @uri.to_s != url
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
    validate_valid_options!(options, :username, :password, :url)
    
    authorization = Configuration.instance
    options.each do |key, value|
      authorization.send(:"#{key}=", value)
    end
    
    authorization
  end
end