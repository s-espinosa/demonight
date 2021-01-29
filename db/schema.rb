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

ActiveRecord::Schema.define(version: 20210129072024) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "demo_nights", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "status", default: 0
    t.date "final_date"
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.string "group_members"
    t.string "name"
    t.string "project_type"
    t.boolean "final_confirmation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "demo_night_id"
    t.integer "user_id"
    t.text "note"
    t.float "archived_average_representation"
    t.float "archived_average_challenge"
    t.float "archived_average_wow"
    t.float "archived_average_total"
    t.string "description"
    t.index ["demo_night_id"], name: "index_projects_on_demo_night_id"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.string "email"
    t.string "nickname"
    t.string "github"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
  end

  create_table "votes", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "project_id"
    t.integer "representation"
    t.integer "challenge"
    t.integer "wow"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_votes_on_project_id"
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  add_foreign_key "projects", "demo_nights"
  add_foreign_key "projects", "users"
  add_foreign_key "votes", "projects"
  add_foreign_key "votes", "users"
end
