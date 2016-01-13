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

ActiveRecord::Schema.define(version: 20160112235244) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "committees", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "slug"
    t.string   "animator_email"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "committees", ["animator_email"], name: "index_committees_on_animator_email", using: :btree
  add_index "committees", ["event_id"], name: "index_committees_on_event_id", using: :btree

  create_table "gadget_files", force: :cascade do |t|
    t.string   "url"
    t.text     "html"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.integer  "people_id"
    t.integer  "parent_id"
    t.integer  "recruiter_id"
    t.integer  "user_id"
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "phone_number"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "contacted"
    t.boolean  "updated_from_nb"
  end

  add_index "people", ["parent_id"], name: "index_people_on_parent_id", using: :btree
  add_index "people", ["people_id"], name: "index_people_on_people_id", using: :btree
  add_index "people", ["recruiter_id"], name: "index_people_on_recruiter_id", using: :btree
  add_index "people", ["user_id"], name: "index_people_on_user_id", using: :btree

  create_table "synchronizations", force: :cascade do |t|
    t.string   "event"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "access_token"
    t.string   "refresh_token"
    t.datetime "expires_at"
    t.boolean  "root"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
