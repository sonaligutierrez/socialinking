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

ActiveRecord::Schema.define(version: 20181103024332) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id"
    t.index ["account_id"], name: "index_categories_on_account_id"
  end

  create_table "facebook_users", force: :cascade do |t|
    t.string "fb_username"
    t.string "fb_name"
    t.string "fb_avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "dni"
  end

  create_table "fb_sessions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "disabled", default: false
    t.string "login"
    t.string "pass"
    t.bigint "proxy_id"
    t.index ["proxy_id"], name: "index_fb_sessions_on_proxy_id"
  end

  create_table "folders", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "post_comments", force: :cascade do |t|
    t.datetime "date"
    t.text "comment"
    t.bigint "facebook_user_id"
    t.bigint "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id"
    t.string "id_comment"
    t.string "reactions"
    t.string "reactions_description"
    t.string "responses"
    t.string "date_comment"
    t.index ["category_id"], name: "index_post_comments_on_category_id"
    t.index ["facebook_user_id"], name: "index_post_comments_on_facebook_user_id"
    t.index ["post_id"], name: "index_post_comments_on_post_id"
  end

  create_table "post_creator_likes", force: :cascade do |t|
    t.bigint "facebook_users_id"
    t.bigint "post_creators_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facebook_users_id"], name: "index_post_creator_likes_on_facebook_users_id"
    t.index ["post_creators_id"], name: "index_post_creator_likes_on_post_creators_id"
  end

  create_table "post_creators", force: :cascade do |t|
    t.string "fan_page"
    t.string "url"
    t.string "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id"
    t.string "cookie_info"
    t.bigint "fb_session_id"
    t.bigint "proxy_id"
    t.boolean "get_likes", default: false
    t.integer "fb_page_session"
    t.index ["account_id"], name: "index_post_creators_on_account_id"
    t.index ["fb_session_id"], name: "index_post_creators_on_fb_session_id"
    t.index ["proxy_id"], name: "index_post_creators_on_proxy_id"
  end

  create_table "post_reactions", force: :cascade do |t|
    t.text "reaction"
    t.bigint "facebook_users_id"
    t.bigint "posts_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facebook_users_id"], name: "index_post_reactions_on_facebook_users_id"
    t.index ["posts_id"], name: "index_post_reactions_on_posts_id"
  end

  create_table "post_shared", force: :cascade do |t|
    t.bigint "facebook_users_id"
    t.bigint "posts_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facebook_users_id"], name: "index_post_shared_on_facebook_users_id"
    t.index ["posts_id"], name: "index_post_shared_on_posts_id"
  end

  create_table "posts", force: :cascade do |t|
    t.date "date"
    t.date "post_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "post_creator_id"
    t.string "url"
    t.string "title"
    t.string "description"
    t.string "image"
    t.bigint "folder_id"
    t.boolean "get_comments", default: false
    t.boolean "get_reactions", default: false
    t.boolean "get_shared", default: false
    t.index ["folder_id"], name: "index_posts_on_folder_id"
    t.index ["post_creator_id"], name: "index_posts_on_post_creator_id"
  end

  create_table "proxies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "disabled", default: false
  end

  create_table "scraping_logs", force: :cascade do |t|
    t.datetime "scraping_date"
    t.time "exec_time"
    t.integer "total_comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "post_id"
    t.string "message"
    t.index ["post_id"], name: "index_scraping_logs_on_post_id"
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
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "categories", "accounts"
  add_foreign_key "fb_sessions", "proxies"
  add_foreign_key "post_comments", "categories"
  add_foreign_key "post_comments", "facebook_users"
  add_foreign_key "post_comments", "posts"
  add_foreign_key "post_creator_likes", "facebook_users", column: "facebook_users_id"
  add_foreign_key "post_creator_likes", "post_creators", column: "post_creators_id"
  add_foreign_key "post_creators", "accounts"
  add_foreign_key "post_creators", "fb_sessions"
  add_foreign_key "post_creators", "proxies"
  add_foreign_key "post_reactions", "facebook_users", column: "facebook_users_id"
  add_foreign_key "post_reactions", "posts", column: "posts_id"
  add_foreign_key "post_shared", "facebook_users", column: "facebook_users_id"
  add_foreign_key "post_shared", "posts", column: "posts_id"
  add_foreign_key "posts", "folders"
  add_foreign_key "posts", "post_creators"
  add_foreign_key "scraping_logs", "posts"
end
