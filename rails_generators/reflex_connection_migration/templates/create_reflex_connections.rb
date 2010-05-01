class CreateReflexConnections < ActiveRecord::Migration
  def self.up
    create_table :reflex_connections do |t|
      t.string  :provider,          :null => false
      t.string  :authorizable_type, :null => false
      t.integer :authorizable_id,   :null => false
      t.string  :uuid,              :null => false
      t.timestamps
    end
    
    add_index :reflex_connections, [:authorizable_type, :authorizable_id], :unique => false, :name => 'reflex_connection_authorizable'
  end
  
  def self.down
    drop_table :reflex_connections
  end
end