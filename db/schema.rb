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

ActiveRecord::Schema[8.0].define(version: 2025_02_21_210356) do
  create_table "assessments", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "asvs_version_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asvs_version_id"], name: "index_assessments_on_asvs_version_id"
    t.index ["user_id"], name: "index_assessments_on_user_id"
  end

  create_table "asvs_versions", force: :cascade do |t|
    t.string "name"
    t.string "version"
    t.text "description"
    t.text "json_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "requirements", force: :cascade do |t|
    t.integer "asvs_version_id", null: false
    t.integer "parent_id"
    t.string "shortcode"
    t.integer "ordinal"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "l1_required"
    t.string "l1_requirement"
    t.boolean "l2_required"
    t.string "l2_requirement"
    t.boolean "l3_required"
    t.string "l3_requirement"
    t.text "cwe"
    t.text "nist"
    t.index ["asvs_version_id"], name: "index_requirements_on_asvs_version_id"
  end

  create_table "responses", force: :cascade do |t|
    t.integer "assessment_id", null: false
    t.integer "requirement_id", null: false
    t.boolean "met_requirement"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "applicable"
    t.index ["assessment_id"], name: "index_responses_on_assessment_id"
    t.index ["requirement_id"], name: "index_responses_on_requirement_id"
  end

  create_table "sharing_urls", force: :cascade do |t|
    t.integer "assessment_id", null: false
    t.integer "user_id", null: false
    t.string "uuid"
    t.datetime "expires_at"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assessment_id"], name: "index_sharing_urls_on_assessment_id"
    t.index ["user_id"], name: "index_sharing_urls_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "assessments", "asvs_versions"
  add_foreign_key "assessments", "users"
  add_foreign_key "requirements", "asvs_versions"
  add_foreign_key "responses", "assessments"
  add_foreign_key "responses", "requirements"
  add_foreign_key "sharing_urls", "assessments"
  add_foreign_key "sharing_urls", "users"
end
