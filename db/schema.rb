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

ActiveRecord::Schema.define(version: 20161016201924) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blazer_audits", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "query_id"
    t.text     "statement"
    t.string   "data_source"
    t.datetime "created_at"
  end

  create_table "blazer_checks", force: :cascade do |t|
    t.integer  "creator_id"
    t.integer  "query_id"
    t.string   "state"
    t.string   "schedule"
    t.text     "emails"
    t.string   "check_type"
    t.text     "message"
    t.datetime "last_run_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blazer_dashboard_queries", force: :cascade do |t|
    t.integer  "dashboard_id"
    t.integer  "query_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blazer_dashboards", force: :cascade do |t|
    t.integer  "creator_id"
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blazer_queries", force: :cascade do |t|
    t.integer  "creator_id"
    t.string   "name"
    t.text     "description"
    t.text     "statement"
    t.string   "data_source"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "domain_entries", force: :cascade do |t|
    t.string   "data_type",  null: false
    t.string   "method",     null: false
    t.string   "pattern",    null: false
    t.integer  "domain_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain_id"], name: "index_domain_entries_on_domain_id", using: :btree
  end

  create_table "domains", force: :cascade do |t|
    t.string   "root_domain", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "news_articles", force: :cascade do |t|
    t.string   "author"
    t.text     "body"
    t.text     "description"
    t.text     "keywords"
    t.string   "section"
    t.datetime "datetime"
    t.string   "title"
    t.string   "root_domain",     null: false
    t.string   "url",             null: false
    t.integer  "scrape_query_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["author"], name: "index_news_articles_on_author", using: :btree
    t.index ["created_at"], name: "index_news_articles_on_created_at", using: :btree
    t.index ["datetime"], name: "index_news_articles_on_datetime", using: :btree
    t.index ["root_domain"], name: "index_news_articles_on_root_domain", using: :btree
    t.index ["scrape_query_id"], name: "index_news_articles_on_scrape_query_id", using: :btree
    t.index ["title"], name: "index_news_articles_on_title", using: :btree
    t.index ["url"], name: "index_news_articles_on_url", unique: true, using: :btree
  end

  create_table "scrape_queries", force: :cascade do |t|
    t.string   "query",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["query"], name: "index_scrape_queries_on_query", unique: true, using: :btree
  end

  create_table "training_logs", force: :cascade do |t|
    t.string   "root_domain",                           null: false
    t.string   "url",                                   null: false
    t.string   "trained_status",  default: "untrained", null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "scrape_query_id"
    t.index ["root_domain", "trained_status"], name: "index_training_logs_on_root_domain_and_trained_status", using: :btree
    t.index ["root_domain"], name: "index_training_logs_on_root_domain", using: :btree
    t.index ["scrape_query_id"], name: "index_training_logs_on_scrape_query_id", using: :btree
    t.index ["trained_status", "updated_at"], name: "index_training_logs_on_trained_status_and_updated_at", using: :btree
    t.index ["trained_status"], name: "index_training_logs_on_trained_status", using: :btree
    t.index ["url"], name: "index_training_logs_on_url", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "api_key",                             null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.index ["api_key"], name: "index_users_on_api_key", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
