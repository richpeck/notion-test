# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 4) do

  create_table "associations", force: :cascade do |t|
    t.integer "user_id"
    t.string "associatiable_type"
    t.integer "associatiable_id"
    t.string "associated_type"
    t.integer "associated_id"
    t.index ["associated_type", "associated_id"], name: "index_associations_on_associated_type_and_associated_id"
    t.index ["associatiable_type", "associatiable_id", "associated_type", "associated_id"], name: "association_index", unique: true
    t.index ["associatiable_type", "associatiable_id"], name: "index_associations_on_associatiable_type_and_associatiable_id"
    t.index ["user_id"], name: "index_associations_on_user_id"
  end

  create_table "pages", force: :cascade do |t|
    t.integer "user_id"
    t.string "title"
    t.text "description"
    t.integer "font"
    t.boolean "small"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_pages_on_user_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
    t.index ["user_id"], name: "user_id_unique", unique: true
  end

  create_table "properties", force: :cascade do |t|
    t.integer "user_id"
    t.integer "type", default: 0
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_properties_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "last_signed_in_ip"
    t.datetime "last_signed_in_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "email_unique", unique: true
  end

end
