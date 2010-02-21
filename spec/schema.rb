ActiveRecord::Schema.define :version => 0 do
  create_table :reflex_connections do |t|
    t.string  :provider,          :null => false
    t.string  :authorizable_type, :null => false
    t.integer :authorizable_id,   :null => false
    t.string  :uuid,              :null => false
    t.timestamps
  end
  
  create_table :authorizables do |t|
    t.timestamps
  end

  add_index :reflex_connections, [:authorizable_type, :authorizable_id]
end