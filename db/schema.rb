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

ActiveRecord::Schema.define(version: 20180523195201) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "commentaries", force: :cascade do |t|
    t.date "date"
    t.text "commentary"
    t.bigint "facebook_users_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "posts_id"
    t.index ["facebook_users_id"], name: "index_commentaries_on_facebook_users_id"
    t.index ["posts_id"], name: "index_commentaries_on_posts_id"
  end

  create_table "facebook_users", force: :cascade do |t|
    t.string "fb_username"
    t.string "fb_name"
    t.string "fb_avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "post_creators", force: :cascade do |t|
    t.string "fan_page"
    t.string "url"
    t.string "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.date "date"
    t.date "post_date"
    t.bigint "post_creators_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "accounts_id"
    t.index ["accounts_id"], name: "index_posts_on_accounts_id"
    t.index ["post_creators_id"], name: "index_posts_on_post_creators_id"
  end

  create_table "scraping_logs", force: :cascade do |t|
    t.date "scraping_date"
    t.time "exec_time"
    t.integer "total_comment"
    t.bigint "posts_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["posts_id"], name: "index_scraping_logs_on_posts_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "commentaries", "facebook_users", column: "facebook_users_id"
  add_foreign_key "commentaries", "posts", column: "posts_id"
  add_foreign_key "posts", "accounts", column: "accounts_id"
  add_foreign_key "posts", "post_creators", column: "post_creators_id"
  add_foreign_key "scraping_logs", "posts", column: "posts_id"
end
