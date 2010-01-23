module Reflex
  class System < Base
    class << self
      # Returns an array of available methods
      def list_methods
        call("System.listMethods")
      end
    
      # Returns the signature of a given method
      def method_signature(method)
        call("System.methodSignature", method)
      end
    
      # Returns the description of a given method
      def method_description(method)
        call("System.methodDescription", method)
      end
    
      # Returns help for a given method
      def method_help(method)
        call("System.methodHelp", method)
      end
    end
  end
end