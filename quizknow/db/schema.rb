# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 4) do

  create_table "authtokens", :force => true do |t|
    t.string "username", :default => "", :null => false
    t.string "token",    :default => "", :null => false
    t.string "secret",   :default => "", :null => false
  end

  add_index "authtokens", ["username"], :name => "index_authtokens_on_username", :unique => true

  create_table "conversions", :force => true do |t|
    t.string   "quizlet_url"
    t.string   "quizlet_name"
    t.string   "quizlet_description"
    t.integer  "iknow_list_id"
    t.text     "quizlet_definitions"
    t.string   "iknow_username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cue_language_code"
    t.string   "response_language_code"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :default => "", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

end
