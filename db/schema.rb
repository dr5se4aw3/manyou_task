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

ActiveRecord::Schema.define(version: 2020_03_13_014432) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "label_on_tasks", force: :cascade do |t|
    t.bigint "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "label_id"
    t.index ["label_id"], name: "index_label_on_tasks_on_label_id"
    t.index ["task_id"], name: "index_label_on_tasks_on_task_id"
  end

  create_table "labels", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title", null: false
    t.text "detail", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "deadline", default: -> { "(CURRENT_DATE + '1 day'::interval)" }, null: false
    t.string "status", default: "未着手", null: false
    t.integer "priority", default: 0, null: false
    t.bigint "user_id"
    t.index ["title", "status"], name: "index_tasks_on_title_and_status"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "label_on_tasks", "labels"
  add_foreign_key "label_on_tasks", "tasks"
  add_foreign_key "tasks", "users"
end
