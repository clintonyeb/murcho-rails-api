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

ActiveRecord::Schema.define(version: 2019_02_01_000508) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actions", force: :cascade do |t|
    t.integer "action_type"
    t.bigint "recipient"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "app_feedbacks", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "churches", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.string "photo"
    t.string "motto"
    t.boolean "trash", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "head_office_id"
    t.index ["head_office_id"], name: "index_churches_on_head_office_id"
  end

  create_table "event_exceptions", force: :cascade do |t|
    t.bigint "event_schema_id"
    t.datetime "exception_date"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.index ["event_schema_id"], name: "index_event_exceptions_on_event_schema_id"
  end

  create_table "event_groups", force: :cascade do |t|
    t.bigint "event_schema_id"
    t.bigint "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_schema_id"], name: "index_event_groups_on_event_schema_id"
    t.index ["group_id"], name: "index_event_groups_on_group_id"
  end

  create_table "event_schemas", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string "recurrence"
    t.integer "duration"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_all_day", default: false
    t.boolean "is_recurring", default: false
    t.integer "color", default: 0
    t.bigint "church_id"
    t.index ["church_id"], name: "index_event_schemas_on_church_id"
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
    t.integer "membership_status"
    t.bigint "church_id"
    t.boolean "trash", default: false
    t.date "date_joined"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "thumbnail"
    t.string "member_id", null: false
    t.index ["church_id"], name: "index_people_on_church_id"
  end

  create_table "person_details", force: :cascade do |t|
    t.string "other_names"
    t.string "date_of_birth"
    t.string "place_of_birth"
    t.integer "age"
    t.string "day_born"
    t.integer "gender"
    t.string "house_number"
    t.string "street_name"
    t.string "location"
    t.string "hometown"
    t.string "hometown_address"
    t.string "education_level"
    t.string "occupation"
    t.string "cell_phone_1"
    t.string "cell_phone_2"
    t.string "email"
    t.string "photo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "person_id"
    t.date "date_of_baptism"
    t.string "place_of_baptism"
    t.string "pastor_or_ministry"
    t.date "confirmation_date"
    t.string "place_of_confirmation"
    t.boolean "communicant_status"
    t.string "generational_group"
    t.string "interest_group"
    t.string "special_interests"
    t.string "position_in_church"
    t.string "church_position_period"
    t.string "name_of_mother"
    t.string "name_of_father"
    t.string "marital_status"
    t.string "name_of_spouse"
    t.string "spouse_contact"
    t.string "names_of_children"
    t.index ["person_id"], name: "index_person_details_on_person_id"
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
    t.string "email_confirmed_token"
    t.boolean "email_confirmed", default: false
    t.datetime "email_confrimed_at"
    t.datetime "email_confirmed_sent_at"
    t.string "reset_password_token"
    t.datetime "reset_password_created_at"
  end

  add_foreign_key "event_exceptions", "event_schemas"
  add_foreign_key "event_groups", "event_schemas"
  add_foreign_key "event_groups", "groups"
  add_foreign_key "groups", "churches"
  add_foreign_key "people", "churches"
  add_foreign_key "person_details", "people"
  add_foreign_key "person_groups", "groups"
  add_foreign_key "person_groups", "people"
  add_foreign_key "person_profiles", "people"
end
