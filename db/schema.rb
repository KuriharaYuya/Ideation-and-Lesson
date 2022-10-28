# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_10_28_134405) do
  create_table "comments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "micropost_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "content"
  end

  create_table "lifelogs", force: :cascade do |t|
    t.string "title", default: "Untitled"
    t.date "log_date"
    t.datetime "start_datetime"
    t.datetime "end_datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "calender"
    t.string "screen_time"
    t.string "overview"
    t.boolean "tweeted?", default: false
    t.integer "assumption_minutes"
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "micropost_id"
    t.integer "comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "microposts", force: :cascade do |t|
    t.string "title"
    t.string "explain_post"
    t.string "post_type"
    t.string "engagement_status"
    t.datetime "start_datetime"
    t.datetime "end_datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.boolean "verified", default: false
    t.integer "lifelog_id"
    t.integer "assumption_minutes"
    t.integer "consuming_minutes"
    t.date "exec_date"
    t.string "video"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
  end

  create_table "user_settings", force: :cascade do |t|
    t.integer "user_id"
    t.integer "tweet_lifelog_date", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "post_lifelog_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.boolean "admin"
    t.string "bio"
  end

  create_table "verifications", force: :cascade do |t|
    t.integer "user_id"
    t.integer "micropost_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
