# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 2) do

  create_table "reflex_connections", :force => true do |t|
    t.string   "provider",          :null => false
    t.string   "authorizable_type", :null => false
    t.integer  "authorizable_id",   :null => false
    t.string   "uuid",              :null => false
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "reflex_connections", ["authorizable_type", "authorizable_id"], :name => "index_reflex_connections_on_authorizable_type_and_authorizable_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "name",              :null => false
    t.string   "login",             :null => true
    t.string   "crypted_password",  :null => true
    t.string   "password_salt",     :null => true
    t.string   "persistence_token", :null => false
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

end
