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

ActiveRecord::Schema.define(version: 2021_03_24_065837) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "lecture_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["lecture_id"], name: "index_bookmarks_on_lecture_id"
    t.index ["user_id", "lecture_id"], name: "index_bookmarks_on_user_id_and_lecture_id", unique: true
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "group_point_histories", force: :cascade do |t|
    t.integer "point_type"
    t.float "amount"
    t.bigint "group_id", null: false
    t.bigint "group_point_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_group_point_histories_on_group_id"
    t.index ["group_point_id"], name: "index_group_point_histories_on_group_point_id"
  end

  create_table "group_points", force: :cascade do |t|
    t.float "current_point"
    t.float "total_point"
    t.bigint "group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_group_points_on_group_id"
  end

  create_table "group_profiles", force: :cascade do |t|
    t.text "content"
    t.bigint "group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_group_profiles_on_group_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "instagram_name"
    t.string "twitter_name"
    t.string "profile_image"
    t.string "header_image"
    t.text "profile"
  end

  create_table "helpfuls", force: :cascade do |t|
    t.integer "review_id"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "review_id"], name: "index_helpfuls_on_user_id_and_review_id", unique: true
  end

  create_table "lectures", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.bigint "teacher_id", null: false
    t.index ["name"], name: "index_lectures_on_name"
    t.index ["teacher_id"], name: "index_lectures_on_teacher_id"
    t.index ["user_id", "updated_at"], name: "index_lectures_on_user_id_and_updated_at"
    t.index ["user_id"], name: "index_lectures_on_user_id"
  end

  create_table "news", force: :cascade do |t|
    t.string "title"
    t.text "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "visitor_id", null: false
    t.integer "visited_id", null: false
    t.string "action", default: "", null: false
    t.boolean "checked", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "review_id"
    t.index ["review_id"], name: "index_notifications_on_review_id"
    t.index ["visited_id"], name: "index_notifications_on_visited_id"
    t.index ["visitor_id"], name: "index_notifications_on_visitor_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id", null: false
    t.bigint "lecture_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "score", null: false
    t.index ["lecture_id"], name: "index_reviews_on_lecture_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "teachers", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "created_at"], name: "index_teachers_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_teachers_on_user_id"
  end

  create_table "user_group_relations", force: :cascade do |t|
    t.integer "user_id", default: 0, null: false
    t.integer "group_id", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "admin", default: false
    t.index ["group_id"], name: "index_user_group_relations_on_group_id"
    t.index ["user_id", "group_id"], name: "index_user_group_relations_on_user_id_and_group_id", unique: true
    t.index ["user_id"], name: "index_user_group_relations_on_user_id"
  end

  create_table "user_point_histories", force: :cascade do |t|
    t.integer "point_type"
    t.float "amount"
    t.bigint "user_id", null: false
    t.bigint "user_point_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_point_histories_on_user_id"
    t.index ["user_point_id"], name: "index_user_point_histories_on_user_point_id"
  end

  create_table "user_points", force: :cascade do |t|
    t.float "current_point"
    t.float "total_point"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_points_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "admin", default: false
    t.integer "grade"
    t.integer "gender"
    t.integer "faculty"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.text "message"
    t.boolean "is_deleted", default: false, null: false
    t.string "twitter_name"
    t.string "instagram_name"
    t.string "image"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bookmarks", "lectures"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "group_point_histories", "group_points"
  add_foreign_key "group_point_histories", "groups"
  add_foreign_key "group_points", "groups"
  add_foreign_key "group_profiles", "groups"
  add_foreign_key "lectures", "teachers"
  add_foreign_key "lectures", "users"
  add_foreign_key "reviews", "lectures"
  add_foreign_key "reviews", "users"
  add_foreign_key "teachers", "users"
  add_foreign_key "user_point_histories", "user_points"
  add_foreign_key "user_point_histories", "users"
  add_foreign_key "user_points", "users"
end
