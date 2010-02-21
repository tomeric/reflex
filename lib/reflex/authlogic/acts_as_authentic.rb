module Reflex
  module Authlogic
    module ActsAsAuthentic
      # Adds in the neccesary modules for acts_as_authentic to include and also 
      # disables password validation if an OAuth server is being used.
      def self.included(base)
        base.class_eval do
          add_acts_as_authentic_module(Methods, :prepend)
        end
      end
       
      module Methods
        def self.included(base)
          # return unless base.column_names.include?(:react_user_id)

          [:validates_length_of_password_field_options,
           :validates_confirmation_of_password_field_options,
           :validates_length_of_password_confirmation_field_options,
           :validates_length_of_login_field_options,
           :validates_format_of_login_field_options].each do |validate_options|
            current_options = base.send(validate_options)
            
            base.cattr_accessor "original_#{validate_options}"
            base.send("original_#{validate_options}=", current_options.dup)
            
            new_options = current_options.merge(:if => nil, :unless => :saving_for_react?)
            
            base.send("#{validate_options}=", new_options)
          end

          base.class_eval do
            has_many :reflex_connections, :as => :authorizable, :autosave => true,
                     :class_name => 'Reflex::Authlogic::Connection'

            def saving_for_react?
              reflex_connections.present?
            end

            def self.find_by_react_user_id(react_id)
              connection = Reflex::Authlogic::Connection.find_by_authorizable_type_and_uuid(class_name, react_id)
              connection && connection.authorizable
            end
            
            def self.create_for_react(provider, react_profile = nil)
              record = new()
              connection = record.reflex_connections.build(:provider => provider)
              
              if react_profile
                record.react_profile = react_profile if record.respond_to?(:react_profile=)
              end
              
              record.save_without_session_maintenance
              [record, connection]
            end
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, Reflex::Authlogic::ActsAsAuthentic)