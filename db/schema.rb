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

ActiveRecord::Schema.define(version: 20141027025023) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "favorites", force: true do |t|
    t.integer  "user_id"
    t.integer  "opening_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "openings", force: true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.string   "description"
    t.string   "timeframe"
    t.integer  "pay_amount"
    t.string   "pay_type"
    t.integer  "num_slots"
    t.date     "expires_on"
    t.boolean  "expire_notified", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "openings_users", id: false, force: true do |t|
    t.integer "user_id",    null: false
    t.integer "opening_id", null: false
  end

  create_table "projects", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "photo_url"
    t.boolean  "approved",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects_users", id: false, force: true do |t|
    t.integer "user_id",    null: false
    t.integer "project_id", null: false
  end

  create_table "skill_links", force: true do |t|
    t.integer  "skill_id"
    t.integer  "skillable_id"
    t.string   "skillable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skills", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "netid"
    t.string   "email"
    t.string   "year"
    t.string   "college"
    t.string   "division"
    t.string   "title"
    t.boolean  "is_admin",            default: false
    t.string   "photo_url"
    t.string   "github_url"
    t.string   "linkedin_url"
    t.text     "bio"
    t.text     "past_experiences"
    t.string   "resume_file_name"
    t.string   "resume_content_type"
    t.integer  "resume_file_size"
    t.datetime "resume_updated_at"
    t.boolean  "has_logged_in",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
