class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name,              :null => true
      t.string :login,             :null => true
      t.string :crypted_password,  :null => true
      t.string :password_salt,     :null => true
      t.string :persistence_token, :null => true
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
