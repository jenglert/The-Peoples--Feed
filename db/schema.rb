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

ActiveRecord::Schema.define(:version => 20090818143432) do

  create_table "blog_posts", :force => true do |t|
    t.string   "title"
    t.string   "post"
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
  end

  add_index "comments", ["user_id"], :name => "fk_comments_user"

  create_table "feed_item_categories", :force => true do |t|
    t.string  "feed_item_id"
    t.integer "category_id"
  end

  create_table "feed_items", :force => true do |t|
    t.string   "title"
    t.string   "description",     :limit => 4000
    t.string   "item_url"
    t.string   "guid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "feed_id"
    t.datetime "pub_date"
    t.integer  "clicks",                                                        :default => 0
    t.string   "image_thumbnail"
    t.string   "image_url"
    t.string   "image_credits"
    t.integer  "comments_count",                                                :default => 0
    t.decimal  "rating",                          :precision => 8, :scale => 2
  end

  add_index "feed_items", ["feed_id"], :name => "index_feed_items_on_feed_id"
  add_index "feed_items", ["guid"], :name => "index_feed_items_on_guid"

  create_table "feed_parse_logs", :force => true do |t|
    t.integer  "feed_id"
    t.integer  "feed_items_added"
    t.datetime "parse_start"
    t.datetime "parse_finish"
    t.string   "feed_url"
  end

  create_table "feeds", :force => true do |t|
    t.string   "title"
    t.string   "imageUrl"
    t.string   "feedUrl"
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

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
  end

end
