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

ActiveRecord::Schema.define(version: 2022_08_31_184757) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "businesses", force: :cascade do |t|
    t.string "tax_name"
    t.string "tax_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "business_emitter_id", null: false
    t.bigint "business_receiver_id", null: false
    t.string "status"
    t.uuid "invoice_uuid"
    t.decimal "amount_cents", default: "0.0", null: false
    t.string "amount_currency", default: "MXN", null: false
    t.date "emitted_at"
    t.date "expires_at"
    t.date "signed_at"
    t.text "cfdi_digital_stamp"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["business_emitter_id"], name: "index_invoices_on_business_emitter_id"
    t.index ["business_receiver_id"], name: "index_invoices_on_business_receiver_id"
    t.index ["invoice_uuid"], name: "index_invoices_on_invoice_uuid", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.uuid "session_id"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email", default: "", null: false
    t.string "password_digest", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["password_digest"], name: "index_users_on_password_digest", unique: true
  end

  add_foreign_key "invoices", "businesses", column: "business_emitter_id"
  add_foreign_key "invoices", "businesses", column: "business_receiver_id"
  add_foreign_key "sessions", "users"
end
