# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121102215154) do

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 5
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "users", :force => true do |t|
    t.string   "account",                                 :null => false
    t.string   "notify_email"
    t.string   "refresh_token"
    t.string   "auth_token"
    t.datetime "token_issued_at"
    t.datetime "token_expires_at"
    t.integer  "error_count",      :default => 0,         :null => false
    t.boolean  "suspended",        :default => false,     :null => false
    t.datetime "last_checked_at"
    t.datetime "last_notified_at"
    t.string   "check_target",     :default => "default", :null => false
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.integer  "check_interval",   :default => 12,        :null => false
    t.string   "locale"
    t.string   "time_zone",        :default => "UTC",     :null => false
    t.integer  "notify_count",     :default => 0,         :null => false
  end

  add_index "users", ["account"], :name => "index_users_on_account", :unique => true

end
