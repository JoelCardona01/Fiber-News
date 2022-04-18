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

ActiveRecord::Schema.define(version: 2022_04_18_140455) do

  create_table "comments", force: :cascade do |t|
    t.integer "user_id"
    t.string "text"
    t.integer "postid"
    t.integer "parentid"
    t.integer "likes", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "likedcomments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "submission_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["submission_id"], name: "index_likedcomments_on_submission_id"
    t.index ["user_id"], name: "index_likedcomments_on_user_id"
  end

  create_table "likedsubmissions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "submission_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["submission_id"], name: "index_likedsubmissions_on_submission_id"
    t.index ["user_id"], name: "index_likedsubmissions_on_user_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.integer "user_id"
    t.string "url"
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "votes", default: 0
    t.string "text", default: ""
    t.index ["user_id"], name: "index_submissions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "karma", default: 0
    t.string "about", default: ""
  end

end
