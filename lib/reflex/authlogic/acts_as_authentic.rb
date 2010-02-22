require 'reflex/authlogic/connection'
require 'reflex/authlogic/account'
require 'reflex/authlogic/connectable'

module Reflex
  module Authlogic
    module ActsAsAuthentic
      # Adds in the neccesary modules for acts_as_authentic to include.
      def self.included(base)
        base.class_eval do
          add_acts_as_authentic_module(Reflex::Authlogic::Account, :prepend)
          add_acts_as_authentic_module(Reflex::Authlogic::Connectable, :prepend)
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, Reflex::Authlogic::ActsAsAuthentic)