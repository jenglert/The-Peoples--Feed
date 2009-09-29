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

ActiveRecord::Schema.define(:version => 20090922031038) do

  create_table "blog_posts", :force => true do |t|
    t.string   "title"
    t.text     "post"
    t.string   "author"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string  "name"
    t.integer "feed_item_categories_count", :default => 0
    t.boolean "visible",                    :default => true
  end

  add_index "categories", ["name"], :name => "index_categories_on_name"

  create_table "category_merges", :force => true do |t|
    t.string   "merge_src"
    t.integer  "merge_target"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.string   "comment",                        :default => ""
    t.datetime "created_at",                                     :null => false
    t.integer  "commentable_id",                 :default => 0,  :null => false
    t.string   "commentable_type", :limit => 15, :default => "", :null => false
    t.integer  "user_id",                        :default => 0,  :null => false
    t.string   "name"
    t.string   "email"
  end

  add_index "comments", ["user_id"], :name => "fk_comments_user"

  create_table "email_a_friend_messages", :force => true do |t|
    t.string   "recipient_email_address"
    t.string   "sender_email_address"
    t.string   "url"
    t.string   "title"
    t.text     "message"
    t.datetime "date_sent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_subscriptions", :force => true do |t|
    t.string   "email"
    t.integer  "subscription_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feed_item_categories", :force => true do |t|
    t.integer "feed_item_id"
    t.integer "category_id"
  end

  add_index "feed_item_categories", ["category_id"], :name => "category_fk"
  add_index "feed_item_categories", ["feed_item_id"], :name => "feed_item_fk"

  create_table "feed_items", :force => true do |t|
    t.string   "title"
    t.string   "description",                :limit => 4000
    t.string   "item_url"
    t.string   "guid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "feed_id"
    t.datetime "pub_date"
    t.integer  "clicks",                                                                   :default => 0
    t.string   "image_thumbnail"
    t.string   "image_url"
    t.string   "image_credits"
    t.integer  "comments_count",                                                           :default => 0
    t.decimal  "rating",                                     :precision => 8, :scale => 2
    t.integer  "feed_item_categories_count",                                               :default => 0
  end

  add_index "feed_items", ["feed_id"], :name => "index_feed_items_on_feed_id"
  add_index "feed_items", ["guid"], :name => "index_feed_items_on_guid"
  add_index "feed_items", ["rating"], :name => "index_feed_items_on_rating"

  create_table "feed_parse_logs", :force => true do |t|
    t.integer  "feed_id"
    t.integer  "feed_items_added"
    t.datetime "parse_start"
    t.datetime "parse_finish"
    t.string   "feed_url"
  end

  add_index "feed_parse_logs", ["feed_id"], :name => "index_feed_parse_logs_on_feed_id"

  create_table "feed_parse_stats", :force => true do |t|
    t.integer "feed_id",          :null => false
    t.date    "parse_day"
    t.integer "feed_items_added"
  end

  create_table "feeds", :force => true do |t|
    t.string   "title"
    t.string   "image_url"
    t.string   "feed_url"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.integer  "clicks",                                    :default => 0
    t.decimal  "rating",      :precision => 8, :scale => 2
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "user_preferences", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "show_ads"
    t.integer  "favorite_category"
    t.integer  "favorite_feed"
    t.boolean  "hide_member_info",  :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.boolean  "admin",                                   :default => false
  end

end
