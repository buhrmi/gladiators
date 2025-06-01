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

ActiveRecord::Schema[8.0].define(version: 2025_05_31_202918) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.integer "position", default: 0, null: false
    t.string "alt_text"
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "characters", force: :cascade do |t|
    t.string "name"
    t.string "race"
    t.integer "exp"
    t.integer "last_hp"
    t.integer "last_hp_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "deposits", force: :cascade do |t|
    t.string "symbol"
    t.integer "user_id"
    t.decimal "amount"
    t.integer "confirmations"
    t.boolean "confirmed", default: false
    t.string "gateway"
    t.string "txid"
    t.float "fee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "wallet_id"
    t.string "script_pubkey"
    t.string "vout_index"
    t.index ["confirmed"], name: "index_deposits_on_confirmed"
    t.index ["symbol"], name: "index_deposits_on_symbol"
    t.index ["txid"], name: "index_deposits_on_txid"
    t.index ["user_id"], name: "index_deposits_on_user_id"
  end

  create_table "identities", force: :cascade do |t|
    t.string "provider"
    t.string "provider_id"
    t.json "provider_info"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider"], name: "index_identities_on_provider"
    t.index ["provider_id"], name: "index_identities_on_provider_id"
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "slot"
    t.json "stats"
    t.integer "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "sell_symbol", default: "rst", null: false
    t.string "buy_symbol", default: "rst", null: false
    t.decimal "buy_amount", precision: 36, scale: 18, default: "0.0", null: false
    t.decimal "sell_amount", precision: 36, scale: 18, null: false
    t.decimal "remaining_sell_amount", precision: 36, scale: 18, null: false
    t.decimal "remaining_buy_amount", precision: 36, scale: 18, null: false
    t.boolean "funded", default: false, null: false
    t.boolean "completed", default: false, null: false
    t.datetime "cancelled_at"
    t.decimal "price", precision: 36, scale: 18
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["completed", "cancelled_at"], name: "index_orders_on_completed_and_cancelled_at"
    t.index ["created_at"], name: "index_orders_on_created_at"
    t.index ["price"], name: "index_orders_on_price"
    t.index ["sell_symbol", "buy_symbol"], name: "index_orders_on_sell_symbol_and_buy_symbol"
    t.index ["user_id", "cancelled_at"], name: "index_orders_on_user_id_and_cancelled_at"
    t.index ["user_id", "completed"], name: "index_orders_on_user_id_and_completed"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "post_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id", null: false
    t.integer "descendant_id", null: false
    t.integer "generations", null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "post_anc_desc_idx", unique: true
    t.index ["descendant_id"], name: "post_desc_idx"
  end

  create_table "posts", force: :cascade do |t|
    t.integer "user_id"
    t.integer "parent_id"
    t.integer "project_id"
    t.string "content"
    t.string "content_html"
    t.string "oembed_url"
    t.json "oembed_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_posts_on_project_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.string "symbol"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["symbol"], name: "index_projects_on_symbol"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "display_name"
    t.string "bio"
    t.string "password_digest"
    t.string "email", null: false
    t.string "default_currency", default: "BTC"
    t.string "email_verification_token"
    t.boolean "email_verified", default: false, null: false
    t.boolean "hidden", default: false
    t.datetime "last_login_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["hidden"], name: "index_users_on_hidden"
    t.index ["name"], name: "index_users_on_name", unique: true
  end

  create_table "wallets", force: :cascade do |t|
    t.integer "user_id"
    t.string "address"
    t.integer "index", default: 0
    t.string "type", default: "Wallets::Bitcoin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
