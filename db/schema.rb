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

ActiveRecord::Schema.define(version: 2018_12_02_091307) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "churches", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.string "photo"
    t.string "motto"
    t.boolean "trash", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.bigint "church_id"
    t.index ["church_id"], name: "index_groups_on_church_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "photo"
    t.string "phone_number"
    t.string "email"
    t.integer "membership_status"
    t.bigint "church_id"
    t.boolean "trash", default: false
    t.date "date_joined"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["church_id"], name: "index_people_on_church_id"
  end

  create_table "person_groups", force: :cascade do |t|
    t.bigint "person_id"
    t.bigint "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_person_groups_on_group_id"
    t.index ["person_id"], name: "index_person_groups_on_person_id"
  end

  create_table "person_profiles", force: :cascade do |t|
    t.date "date_of_birth"
    t.integer "relation_status"
    t.integer "gender"
    t.bigint "person_id"
    t.string "address"
    t.string "profession"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_person_profiles_on_person_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "photo"
    t.string "phone_number"
    t.string "email"
    t.integer "access_level"
    t.bigint "church_id"
    t.string "password_digest"
    t.string "salt"
    t.string "full_name"
    t.boolean "trash", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "groups", "churches"
  add_foreign_key "people", "churches"
  add_foreign_key "person_groups", "groups"
  add_foreign_key "person_groups", "people"
  add_foreign_key "person_profiles", "people"
end
