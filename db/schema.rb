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

ActiveRecord::Schema.define(version: 1) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "appointments", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "entity_id",   null: false
    t.string   "entity_type", null: false
    t.uuid     "role_id",     null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["entity_id", "role_id"], name: "index_appointments_on_entity_id_and_role_id", using: :btree
    t.index ["entity_id"], name: "index_appointments_on_entity_id", using: :btree
    t.index ["role_id"], name: "index_appointments_on_role_id", using: :btree
  end

  create_table "clients", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "launch_url", null: false
    t.string   "icon_url"
    t.boolean  "available",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_clients_on_name", unique: true, using: :btree
  end

  create_table "groups", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name",        null: false
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["name"], name: "index_groups_on_name", using: :btree
  end

  create_table "identities", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "user_id",                              null: false
    t.uuid     "identity_provider_id",                 null: false
    t.string   "sub",                                  null: false
    t.string   "iat"
    t.string   "hd"
    t.string   "locale"
    t.string   "email"
    t.json     "jwt",                  default: {},    null: false
    t.boolean  "notify_via_email",     default: false, null: false
    t.boolean  "notify_via_sms",       default: false, null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "identity_providers", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name",                             null: false
    t.string   "issuer",                           null: false
    t.string   "client_id",                        null: false
    t.string   "client_secret",                    null: false
    t.string   "alternate_client_id"
    t.json     "configuration"
    t.json     "public_keys"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "scopes",              default: "", null: false
    t.index ["name"], name: "index_identity_providers_on_name", using: :btree
  end

  create_table "json_web_tokens", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "identity_id", null: false
    t.datetime "expires_at",  null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["expires_at"], name: "index_json_web_tokens_on_expires_at", using: :btree
    t.index ["identity_id"], name: "index_json_web_tokens_on_identity_id", using: :btree
  end

  create_table "members", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "group_id",   null: false
    t.uuid     "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_members_on_group_id", using: :btree
    t.index ["user_id"], name: "index_members_on_user_id", using: :btree
  end

  create_table "roles", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "code",        null: false
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["code"], name: "index_roles_on_code", unique: true, using: :btree
    t.index ["name"], name: "index_roles_on_name", unique: true, using: :btree
  end

  create_table "sessions", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "identity_id", null: false
    t.datetime "expires_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "external_id"
    t.string   "salutation"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_foreign_key "appointments", "roles"
  add_foreign_key "identities", "identity_providers"
  add_foreign_key "identities", "users"
  add_foreign_key "json_web_tokens", "identities"
  add_foreign_key "members", "groups"
  add_foreign_key "members", "users"
end
