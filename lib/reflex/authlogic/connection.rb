module Reflex
  module Authlogic
    class Connection < ActiveRecord::Base
      set_table_name 'reflex_connections'

      belongs_to :authorizable, :polymorphic => true
      validates_presence_of :uuid
  
      before_validation_on_create :generate_uuid
  
      private
  
      def generate_uuid
        self.uuid = UUIDTools::UUID.random_create.to_s
      end
    end
  end
end