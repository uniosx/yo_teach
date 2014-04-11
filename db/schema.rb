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

ActiveRecord::Schema.define(version: 20140411140648) do

  create_table "accounts", force: true do |t|
    t.string  "stripe_customer_id"
    t.integer "owner_id"
  end

  add_index "accounts", ["owner_id"], name: "index_accounts_on_owner_id"

  create_table "core_standards", force: true do |t|
    t.string "standard_type", null: false
    t.string "dot_notation",  null: false
    t.string "uri",           null: false
    t.string "guid",          null: false
    t.text   "description",   null: false
  end

  create_table "core_standards_lesson_plans", id: false, force: true do |t|
    t.integer "core_standard_id"
    t.integer "lesson_plan_id"
  end

  create_table "courses", force: true do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "courses", ["user_id"], name: "index_courses_on_user_id"

  create_table "lesson_plan_fields", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "lesson_plan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lesson_plan_fields", ["lesson_plan_id"], name: "index_lesson_plan_fields_on_lesson_plan_id"

  create_table "lesson_plans", force: true do |t|
    t.datetime "start"
    t.datetime "end"
    t.string   "title"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status"
    t.integer  "user_id"
  end

  add_index "lesson_plans", ["course_id"], name: "index_lesson_plans_on_course_id"
  add_index "lesson_plans", ["start"], name: "index_lesson_plans_on_start"
  add_index "lesson_plans", ["user_id"], name: "index_lesson_plans_on_user_id"

  create_table "to_dos", force: true do |t|
    t.string   "body"
    t.boolean  "complete"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "to_dos", ["user_id"], name: "index_to_dos_on_user_id"

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  add_index "users", ["account_id"], name: "index_users_on_account_id"

end
