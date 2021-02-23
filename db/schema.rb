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

ActiveRecord::Schema.define(version: 2021_02_20_013348) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.integer "language_used"
    t.integer "lecture_type"
    t.integer "lecture_term"
    t.integer "lecture_size"
    t.integer "group_work"
    t.bigint "user_id", null: false
    t.index ["group_work"], name: "index_lectures_on_group_work"
    t.index ["language_used"], name: "index_lectures_on_language_used"
    t.index ["lecture_size"], name: "index_lectures_on_lecture_size"
    t.index ["lecture_term"], name: "index_lectures_on_lecture_term"
    t.index ["lecture_type"], name: "index_lectures_on_lecture_type"
    t.index ["name"], name: "index_lectures_on_name", unique: true
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
    t.integer "review_id", null: false
    t.string "action", default: "", null: false
    t.boolean "checked", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["review_id"], name: "index_notifications_on_review_id"
    t.index ["visited_id"], name: "index_notifications_on_visited_id"
    t.index ["visitor_id"], name: "index_notifications_on_visitor_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.bigint "user_id", null: false
    t.bigint "lecture_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "explanation", null: false
    t.float "fairness", null: false
    t.float "recommendation", null: false
    t.float "useful", null: false
    t.float "interesting", null: false
    t.float "difficulty"
    t.float "score"
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "lectures", "users"
  add_foreign_key "reviews", "lectures"
  add_foreign_key "reviews", "users"
  add_foreign_key "teachers", "users"
end
