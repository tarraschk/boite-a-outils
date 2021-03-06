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

ActiveRecord::Schema.define(version: 20161016093715) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"

  create_table "addresses", force: :cascade do |t|
    t.string   "address1"
    t.string   "city"
    t.string   "zip"
    t.integer  "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "address2"
    t.string   "address3"
  end

  add_index "addresses", ["person_id"], name: "index_addresses_on_person_id", using: :btree
  add_index "addresses", ["zip"], name: "index_addresses_on_zip", using: :btree

  create_table "comites", force: :cascade do |t|
    t.integer  "number"
    t.integer  "typecomite"
    t.string   "slug"
    t.string   "title"
    t.string   "desc1"
    t.string   "desc2"
    t.string   "coordinates"
    t.boolean  "active"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "committees", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "slug"
    t.string   "animator_email"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "people_id"
    t.string   "name"
  end

  add_index "committees", ["animator_email"], name: "index_committees_on_animator_email", using: :btree
  add_index "committees", ["event_id"], name: "index_committees_on_event_id", using: :btree
  add_index "committees", ["people_id"], name: "index_committees_on_people_id", using: :btree

  create_table "extract_download_logs", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "export_type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "mobile"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "contacted"
    t.boolean  "updated_from_nb"
    t.integer  "support_level"
    t.string   "tags"
    t.string   "mandat"
    t.string   "phone"
    t.string   "nation_builder_error"
    t.boolean  "activated",            default: true
    t.text     "notes"
    t.string   "contact_mailing_list"
  end

  add_index "people", ["parent_id"], name: "index_people_on_parent_id", using: :btree
  add_index "people", ["people_id"], name: "index_people_on_people_id", using: :btree
  add_index "people", ["recruiter_id"], name: "index_people_on_recruiter_id", using: :btree
  add_index "people", ["tags"], name: "index_people_on_tags", using: :gin
  add_index "people", ["user_id"], name: "index_people_on_user_id", using: :btree

  create_table "synchronizations", force: :cascade do |t|
    t.string   "event"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_to_person_relations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_to_person_relations", ["person_id"], name: "index_user_to_person_relations_on_person_id", using: :btree
  add_index "user_to_person_relations", ["user_id"], name: "index_user_to_person_relations_on_user_id", using: :btree

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

  add_foreign_key "addresses", "people"
end
