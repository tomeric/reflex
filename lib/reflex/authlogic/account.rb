module Reflex
  module Authlogic
    module Account
      def self.included(base)
        base.send(:extend, ClassMethods)
        base.send(:include, InstanceMethods)
        
        base.send(:has_many, :reflex_connections, :as => :authorizable, :autosave => true,
                             :class_name => 'Reflex::Authlogic::Connection')
        
        # Overwrite authlogic validation options so they are skipped when saving a react account:
        [:validates_uniqueness_of_login_field_options,
         :validates_length_of_password_field_options,
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
      end
      
      module InstanceMethods
        def saving_for_react?
          reflex_connections.present?
        end
      end
      
      module ClassMethods        
        def find_by_react_user_id(react_id)
          connection = Reflex::Authlogic::Connection.find_by_authorizable_type_and_uuid(class_name, react_id)
          connection && connection.authorizable
        end
        
        def create_for_react(provider, react_profile = nil)
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