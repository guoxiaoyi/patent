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

ActiveRecord::Schema[7.0].define(version: 2024_11_26_145443) do
  create_table "articles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.string "author"
    t.integer "status"
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_articles_on_category_id"
  end

  create_table "categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_categories_on_parent_id"
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "conversation_steps", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "conversation_id", null: false
    t.bigint "sub_feature_id", null: false
    t.integer "status"
    t.text "error_message"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_conversation_steps_on_conversation_id"
    t.index ["deleted_at"], name: "index_conversation_steps_on_deleted_at"
    t.index ["sub_feature_id"], name: "index_conversation_steps_on_sub_feature_id"
  end

  create_table "conversations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "request_id", limit: 36, null: false
    t.string "title"
    t.bigint "user_id", null: false
    t.bigint "feature_id", null: false
    t.bigint "tenant_id", null: false
    t.bigint "project_id", null: false
    t.boolean "processing", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_conversations_on_deleted_at"
    t.index ["feature_id"], name: "index_conversations_on_feature_id"
    t.index ["project_id"], name: "index_conversations_on_project_id"
    t.index ["request_id"], name: "index_conversations_on_request_id", unique: true
    t.index ["tenant_id"], name: "index_conversations_on_tenant_id"
    t.index ["user_id"], name: "index_conversations_on_user_id"
  end

  create_table "customers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "tenant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id"], name: "index_customers_on_tenant_id"
  end

  create_table "features", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.integer "feature_key"
    t.text "prompt"
    t.integer "cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jwt_denylists", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "jti"
    t.datetime "exp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylists_on_jti"
  end

  create_table "payments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "tenant_id", null: false
    t.decimal "amount", precision: 10, scale: 2
    t.string "code"
    t.string "status"
    t.integer "transaction_id"
    t.string "paymentable_type", null: false
    t.bigint "paymentable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["paymentable_type", "paymentable_id"], name: "index_payments_on_paymentable"
    t.index ["tenant_id"], name: "index_payments_on_tenant_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "projects", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "customer_id"
    t.bigint "tenant_id", null: false
    t.bigint "user_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_projects_on_customer_id"
    t.index ["deleted_at"], name: "index_projects_on_deleted_at"
    t.index ["tenant_id"], name: "index_projects_on_tenant_id"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "promotions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "bonus_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recharge_types", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.decimal "price", precision: 10, scale: 2
    t.decimal "discount", precision: 10, scale: 2
    t.integer "amount"
    t.json "rules"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_recharge_types_on_deleted_at"
  end

  create_table "resource_pack_types", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.decimal "price", precision: 10, scale: 2
    t.decimal "discount", precision: 10, scale: 2
    t.integer "amount"
    t.integer "bonus", default: 0
    t.integer "valid_days"
    t.json "rules"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_resource_pack_types_on_deleted_at"
  end

  create_table "resource_packs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "owner_type", null: false
    t.bigint "owner_id", null: false
    t.bigint "resource_pack_type_id", null: false
    t.integer "amount"
    t.integer "status", default: 0, null: false
    t.datetime "valid_from", null: false
    t.datetime "valid_to", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id"], name: "index_resource_packs_on_owner"
    t.index ["resource_pack_type_id"], name: "index_resource_packs_on_resource_pack_type_id"
  end

  create_table "sub_features", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "prompt"
    t.integer "feature_key"
    t.integer "sort_order"
    t.bigint "feature_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feature_id"], name: "index_sub_features_on_feature_id"
  end

  create_table "tenant_managers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "phone", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["phone"], name: "index_tenant_managers_on_phone", unique: true
    t.index ["reset_password_token"], name: "index_tenant_managers_on_reset_password_token", unique: true
  end

  create_table "tenants", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "phone", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.string "subdomain"
    t.string "domain"
    t.integer "billing_mode", default: 0
    t.integer "mode", default: 0
    t.integer "balance", default: 0
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain"], name: "index_tenants_on_domain"
    t.index ["phone"], name: "index_tenants_on_phone", unique: true
    t.index ["reset_password_token"], name: "index_tenants_on_reset_password_token", unique: true
    t.index ["subdomain"], name: "index_tenants_on_subdomain"
  end

  create_table "transactions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "account_type"
    t.integer "account_id"
    t.integer "amount"
    t.integer "transaction_type"
    t.string "transactionable_type"
    t.integer "transactionable_id"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "phone", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "balance", default: 0, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tenant_id", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["phone"], name: "index_users_on_phone"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["tenant_id"], name: "index_users_on_tenant_id"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "verification_codes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "phone"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "articles", "categories"
  add_foreign_key "conversation_steps", "conversations"
  add_foreign_key "conversation_steps", "sub_features"
  add_foreign_key "conversations", "features"
  add_foreign_key "conversations", "projects"
  add_foreign_key "conversations", "tenants"
  add_foreign_key "conversations", "users"
  add_foreign_key "customers", "tenants"
  add_foreign_key "payments", "tenants"
  add_foreign_key "payments", "users"
  add_foreign_key "projects", "customers"
  add_foreign_key "projects", "tenants"
  add_foreign_key "projects", "users"
  add_foreign_key "resource_packs", "resource_pack_types"
  add_foreign_key "sub_features", "features"
  add_foreign_key "users", "tenants"
end
