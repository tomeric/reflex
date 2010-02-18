require 'oauth'
require 'xmlrpc/client'

# unfortunately react's oauth server has <nil />'s, which the ruby XMLRPC
# library does not enable by default, because it is an XML-RPC extension:
# http://ontosys.com/xml-rpc/extensions.php
old_verbose, $VERBOSE = $VERBOSE, nil  
begin
  XMLRPC::Config::ENABLE_NIL_PARSER = true
  XMLRPC::Config::ENABLE_NIL_CREATE = true
ensure
  $VERBOSE = old_verbose
end

module Reflex
  class Base
    def self.call(function, *arguments)
      config = Configuration.instance
      client = XMLRPC::Client.new(config.hostname, config.path, config.port)
      client.call(function, *arguments)
    end
    
    def self.call!(function, *arguments)
      call(function, key, secret, *arguments)
    end
    
    def self.key
      Configuration.instance.key
    end
    
    def self.secret
      Configuration.instance.secret
    end
  end
  
  def self.validate_valid_options!(options, *keys)
    unless options.keys.all? { |key| keys.include?(key) }
      raise "Invalid options: #{(options.keys - keys).join(', ')}"
    end
  end
end