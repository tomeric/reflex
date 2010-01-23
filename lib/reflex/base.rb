require 'xmlrpc/client'

module Reflex
  class Base
    def self.call(function, *arguments)
      config = Configuration.instance
      server = XMLRPC::Client.new(config.hostname, config.path, config.port)
      server.call(function, *arguments)
    end
  end
  
  def self.validate_valid_options!(options, *keys)
    unless options.keys.all? { |key| keys.include?(key) }
      raise "Invalid options: #{(options.keys - keys).join(', ')}"
    end
  end
end