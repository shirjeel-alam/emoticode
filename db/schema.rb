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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140502235410) do

  create_table "authorizations", force: :cascade do |t|
    t.string   "provider",   limit: 255
    t.string   "uid",        limit: 255
    t.string   "token",      limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "handle",     limit: 255
  end

  create_table "categories", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "commentable_type", limit: 4,     null: false
    t.integer "commentable_id",   limit: 4,     null: false
    t.integer "parent_id",        limit: 4
    t.integer "user_id",          limit: 4
    t.text    "content",          limit: 65535, null: false
    t.integer "created_at",       limit: 4,     null: false
  end

  add_index "comments", ["commentable_id"], name: "item_id", using: :btree
  add_index "comments", ["commentable_type", "commentable_id"], name: "object_type", using: :btree
  add_index "comments", ["created_at"], name: "created_at", using: :btree
  add_index "comments", ["parent_id"], name: "parent_id", using: :btree
  add_index "comments", ["parent_id"], name: "parent_id_2", using: :btree
  add_index "comments", ["user_id"], name: "user_id", using: :btree

  create_table "database_connections", force: :cascade do |t|
    t.string  "adapter",  limit: 255, null: false
    t.string  "database", limit: 255, null: false
    t.string  "password", limit: 255
    t.string  "username", limit: 255
    t.string  "host",     limit: 255
    t.string  "encoding", limit: 255
    t.integer "port",     limit: 4
    t.string  "title",    limit: 255
  end

  create_table "events", force: :cascade do |t|
    t.integer  "user_id",        limit: 4
    t.integer  "eventable_type", limit: 4
    t.integer  "eventable_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "data",           limit: 65535
  end

  add_index "events", ["created_at"], name: "index_events_on_created_at", using: :btree
  add_index "events", ["eventable_id"], name: "index_events_on_eventable_id", using: :btree
  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

  create_table "favorites", force: :cascade do |t|
    t.integer "user_id",   limit: 4, null: false
    t.integer "source_id", limit: 4, null: false
  end

  add_index "favorites", ["source_id"], name: "source_id", using: :btree
  add_index "favorites", ["user_id", "source_id"], name: "user_id", using: :btree

  create_table "follows", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.integer  "follow_type", limit: 4
    t.integer  "follow_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "follows", ["follow_id"], name: "index_follows_on_follow_id", using: :btree
  add_index "follows", ["follow_type"], name: "index_follows_on_follow_type", using: :btree
  add_index "follows", ["user_id"], name: "index_follows_on_user_id", using: :btree

  create_table "impressions", force: :cascade do |t|
    t.string   "impressionable_type", limit: 255
    t.integer  "impressionable_id",   limit: 4
    t.integer  "user_id",             limit: 4
    t.string   "controller_name",     limit: 255
    t.string   "action_name",         limit: 255
    t.string   "view_name",           limit: 255
    t.string   "request_hash",        limit: 255
    t.string   "ip_address",          limit: 255
    t.string   "session_hash",        limit: 255
    t.text     "message",             limit: 65535
    t.text     "referrer",            limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", length: {"impressionable_type"=>nil, "message"=>255, "impressionable_id"=>nil}, using: :btree
  add_index "impressions", ["user_id"], name: "index_impressions_on_user_id", using: :btree

  create_table "languages", force: :cascade do |t|
    t.string  "title",         limit: 255,             null: false
    t.string  "name",          limit: 255,             null: false
    t.string  "syntax",        limit: 255,             null: false
    t.integer "sources_count", limit: 4,   default: 0
  end

  add_index "languages", ["name"], name: "name", using: :btree

  create_table "links", force: :cascade do |t|
    t.integer "source_id", limit: 4,  null: false
    t.integer "tag_id",    limit: 4,  null: false
    t.float   "weight",    limit: 24, null: false
  end

  add_index "links", ["source_id", "tag_id"], name: "source_id", using: :btree
  add_index "links", ["tag_id"], name: "entity_value_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.integer  "category_id", limit: 4
    t.string   "title",       limit: 255
    t.string   "name",        limit: 255
    t.text     "body",        limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["category_id"], name: "index_posts_on_category_id", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "profiles", force: :cascade do |t|
    t.integer "user_id",           limit: 4,                       null: false
    t.text    "aboutme",           limit: 16777215
    t.string  "website",           limit: 255
    t.string  "gplus",             limit: 255
    t.integer "avatar",            limit: 1,        default: 0,    null: false
    t.boolean "weekly_newsletter",                  default: true
    t.boolean "follow_mail",                        default: true
  end

  add_index "profiles", ["user_id"], name: "user_id", using: :btree

  create_table "ratings", force: :cascade do |t|
    t.integer "rateable_type", limit: 1,                null: false
    t.integer "rateable_id",   limit: 4,                null: false
    t.integer "votes",         limit: 4,  default: 0
    t.float   "average",       limit: 24, default: 0.0
    t.integer "created_at",    limit: 4,                null: false
  end

  add_index "ratings", ["average"], name: "average", using: :btree
  add_index "ratings", ["created_at"], name: "created_at", using: :btree
  add_index "ratings", ["rateable_id"], name: "object_id", using: :btree
  add_index "ratings", ["rateable_type", "rateable_id"], name: "object_type_2", using: :btree
  add_index "ratings", ["rateable_type"], name: "object_type", using: :btree
  add_index "ratings", ["votes"], name: "votes", using: :btree

  create_table "social_cron", force: :cascade do |t|
    t.integer "last_posted_source_id", limit: 4, null: false
    t.integer "last_run",              limit: 4, null: false
    t.integer "last_random_run",       limit: 4, null: false
  end

  add_index "social_cron", ["last_posted_source_id"], name: "last_posted_source_id", using: :btree

  create_table "sources", force: :cascade do |t|
    t.integer "user_id",         limit: 4
    t.integer "language_id",     limit: 4
    t.integer "private",         limit: 1,          default: 0,     null: false
    t.string  "name",            limit: 255,                        null: false
    t.string  "title",           limit: 255,                        null: false
    t.text    "description",     limit: 65535
    t.integer "created_at",      limit: 4,                          null: false
    t.text    "text",            limit: 4294967295,                 null: false
    t.integer "views",           limit: 4,          default: 0
    t.boolean "socialized",                         default: false
    t.integer "updated_at",      limit: 4,          default: 0
    t.integer "favorites_count", limit: 4,          default: 0
    t.integer "comments_count",  limit: 4,          default: 0
  end

  add_index "sources", ["created_at"], name: "index_sources_on_created_at", using: :btree
  add_index "sources", ["description"], name: "search_index_2", type: :fulltext
  add_index "sources", ["language_id"], name: "language_id", using: :btree
  add_index "sources", ["language_id"], name: "type_id", using: :btree
  add_index "sources", ["name"], name: "name", using: :btree
  add_index "sources", ["private"], name: "index_sources_on_private", using: :btree
  add_index "sources", ["private"], name: "private", using: :btree
  add_index "sources", ["title"], name: "search_index_1", type: :fulltext
  add_index "sources", ["user_id"], name: "author_id", using: :btree
  add_index "sources", ["user_id"], name: "index_sources_on_user_id", using: :btree
  add_index "sources", ["views"], name: "index_sources_on_views", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",          limit: 255,               null: false
    t.text    "value",         limit: 65535,             null: false
    t.integer "sources_count", limit: 4,     default: 0
  end

  add_index "tags", ["name"], name: "name", using: :btree

  create_table "users", force: :cascade do |t|
    t.string  "username",      limit: 255,             null: false
    t.string  "email",         limit: 255,             null: false
    t.string  "password_hash", limit: 32,              null: false
    t.string  "salt",          limit: 10,              null: false
    t.integer "last_login",    limit: 4,   default: 0
    t.string  "last_login_ip", limit: 15
    t.integer "level",         limit: 4,               null: false
    t.integer "status",        limit: 4,               null: false
    t.integer "created_at",    limit: 4,               null: false
    t.integer "updated_at",    limit: 4
    t.integer "is_bot",        limit: 4,   default: 0
  end

  add_index "users", ["created_at"], name: "created_at", using: :btree
  add_index "users", ["email"], name: "email", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["last_login"], name: "last_login", using: :btree
  add_index "users", ["level"], name: "level", using: :btree
  add_index "users", ["password_hash"], name: "hash", using: :btree
  add_index "users", ["status"], name: "status", using: :btree
  add_index "users", ["username", "email"], name: "username", unique: true, using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer "rating_id",  limit: 4,  null: false
    t.integer "user_id",    limit: 4
    t.float   "value",      limit: 24, null: false
    t.integer "created_at", limit: 4,  null: false
  end

  add_index "votes", ["created_at"], name: "timestamp", using: :btree
  add_index "votes", ["rating_id"], name: "rating_id", using: :btree
  add_index "votes", ["user_id"], name: "user_id", using: :btree

end
