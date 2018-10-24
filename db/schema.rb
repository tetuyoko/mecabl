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

ActiveRecord::Schema.define(version: 20160517084409) do

  create_table "crawl_statuses", force: :cascade do |t|
    t.integer  "feed_id",         limit: 4,   default: 0, null: false
    t.integer  "status",          limit: 4,   default: 1, null: false
    t.integer  "error_count",     limit: 4,   default: 0, null: false
    t.string   "error_message",   limit: 255
    t.string   "http_status",     limit: 255
    t.string   "digest",          limit: 255
    t.integer  "update_fequency", limit: 4,   default: 0, null: false
    t.datetime "crawled_at"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "crawl_statuses", ["feed_id"], name: "index_crawl_statuses_on_feed_id", using: :btree

  create_table "entries", force: :cascade do |t|
    t.integer  "feed_id",      limit: 4,     default: 0,  null: false
    t.text     "title",        limit: 65535,              null: false
    t.string   "url",          limit: 255,   default: "", null: false
    t.string   "author",       limit: 255
    t.text     "content",      limit: 65535
    t.string   "digest",       limit: 255
    t.string   "guid",         limit: 255
    t.datetime "published_at",                            null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "version",      limit: 4,     default: 1,  null: false
    t.text     "tag_list",     limit: 65535
    t.integer  "category",     limit: 1,     default: 0,  null: false
    t.string   "thumb_url",    limit: 255
    t.string   "image",        limit: 255
  end

  add_index "entries", ["category"], name: "index_entries_on_category", using: :btree
  add_index "entries", ["digest"], name: "index_entries_on_digest", using: :btree
  add_index "entries", ["feed_id", "guid"], name: "index_entries_on_feed_id_and_guid", unique: true, using: :btree

  create_table "feeds", force: :cascade do |t|
    t.text     "title",       limit: 65535, null: false
    t.string   "url",         limit: 255,   null: false
    t.string   "etag",        limit: 255
    t.string   "feed_url",    limit: 255,   null: false
    t.text     "description", limit: 65535, null: false
    t.datetime "modified_at"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "feeds", ["feed_url"], name: "index_feeds_on_feed_url", unique: true, using: :btree

  create_table "train_histories", force: :cascade do |t|
    t.integer  "entry_id",        limit: 4,             null: false
    t.integer  "status",          limit: 1, default: 0, null: false
    t.integer  "category",        limit: 1, default: 0, null: false
    t.datetime "trained_at"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "train_master_id", limit: 4
  end

  add_index "train_histories", ["category"], name: "index_train_histories_on_category", using: :btree
  add_index "train_histories", ["entry_id"], name: "index_train_histories_on_entry_id", using: :btree
  add_index "train_histories", ["train_master_id"], name: "index_train_histories_on_train_master_id", using: :btree

  create_table "train_masters", force: :cascade do |t|
    t.integer  "mean",         limit: 4,     default: 0, null: false
    t.text     "content_json", limit: 65535
    t.datetime "trained_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

end
