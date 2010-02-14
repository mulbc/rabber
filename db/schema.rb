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

ActiveRecord::Schema.define(:version => 0) do

  create_table "history", :force => true do |t|
    t.integer  "roster_entries_id", :null => false
    t.string   "from",              :null => false
    t.string   "to",                :null => false
    t.string   "message",           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roster_entries", :force => true do |t|
    t.integer  "roster_group_id", :null => false
    t.string   "jid",             :null => false
    t.string   "name"
    t.integer  "subscription",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roster_groups", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name",                            :null => false
    t.string   "password",                        :null => false
    t.string   "status"
    t.string   "digest_md5_nonce"
    t.integer  "digest_md5_nc",    :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
