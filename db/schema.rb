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

ActiveRecord::Schema.define(version: 20170310212850) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "appointments", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "entity_id", null: false
    t.string "entity_type", null: false
    t.uuid "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id", "role_id"], name: "index_appointments_on_entity_id_and_role_id"
    t.index ["entity_id"], name: "index_appointments_on_entity_id"
    t.index ["role_id"], name: "index_appointments_on_role_id"
  end

  create_table "builds", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "service_id", null: false
    t.string "service_version", null: false
    t.string "version", null: false
    t.string "container_repository", null: false
    t.string "container_tag", null: false
    t.datetime "validated_at"
    t.datetime "published_at"
    t.json "permissions", default: {}, null: false
    t.text "release_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_builds_on_id"
  end

  create_table "clients", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "launch_url", null: false
    t.string "icon_url"
    t.boolean "available", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_clients_on_name", unique: true
  end

  create_table "configurations", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "build_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["build_id"], name: "index_configurations_on_build_id"
  end

  create_table "dependencies", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "build_id", null: false
    t.uuid "interface_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["build_id"], name: "index_dependencies_on_build_id"
    t.index ["interface_id"], name: "index_dependencies_on_interface_id"
  end

  create_table "exposures", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "build_id", null: false
    t.uuid "interface_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["build_id"], name: "index_exposures_on_build_id"
    t.index ["interface_id"], name: "index_exposures_on_interface_id"
  end

  create_table "groups", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_groups_on_name"
  end

  create_table "identities", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "identity_provider_id", null: false
    t.string "sub", null: false
    t.string "iat"
    t.string "hd"
    t.string "locale"
    t.string "email"
    t.json "jwt", default: {}, null: false
    t.boolean "notify_via_email", default: false, null: false
    t.boolean "notify_via_sms", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "identity_providers", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "issuer", null: false
    t.string "client_id", null: false
    t.string "client_secret", null: false
    t.string "alternate_client_id"
    t.json "configuration"
    t.json "public_keys"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "scopes", default: "", null: false
    t.datetime "enabled_at"
    t.index ["name"], name: "index_identity_providers_on_name"
  end

  create_table "images", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "screenshot_id", null: false
    t.string "style"
    t.binary "file_contents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["screenshot_id"], name: "index_images_on_screenshot_id"
  end

  create_table "instances", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "platform_id", null: false
    t.uuid "build_id", null: false
    t.json "launch_bindings", default: {}, null: false
    t.datetime "deployed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["build_id"], name: "index_instances_on_build_id"
    t.index ["platform_id"], name: "index_instances_on_platform_id"
  end

  create_table "interfaces", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "uri", null: false
    t.string "version", null: false
    t.integer "ordinal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "json_web_tokens", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "identity_id", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expires_at"], name: "index_json_web_tokens_on_expires_at"
    t.index ["identity_id"], name: "index_json_web_tokens_on_identity_id"
  end

  create_table "licenses", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_licenses_on_name", unique: true
  end

  create_table "logos", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "service_id", null: false
    t.string "style"
    t.binary "file_contents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_logos_on_service_id"
  end

  create_table "members", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "group_id", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_members_on_group_id"
    t.index ["user_id"], name: "index_members_on_user_id"
  end

  create_table "parameters", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "exposure_id", null: false
    t.string "name", null: false
    t.boolean "required"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exposure_id"], name: "index_parameters_on_exposure_id"
  end

  create_table "platforms", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", null: false
    t.uuid "user_id", null: false
    t.text "public_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_platforms_on_user_id"
  end

  create_table "roles", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.boolean "default", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "permissions", default: {}, null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "screenshots", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "caption", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "service_id", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.index ["service_id"], name: "index_screenshots_on_service_id"
  end

  create_table "services", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.uuid "user_id"
    t.string "uri"
    t.string "support_url"
    t.uuid "license_id"
    t.datetime "published_at"
    t.datetime "visible_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.integer "logo_file_size"
    t.datetime "logo_updated_at"
    t.index ["name"], name: "index_services_on_name", unique: true
  end

  create_table "sessions", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "identity_id", null: false
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "surrogates", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "interface_id", null: false
    t.uuid "substitute_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["interface_id"], name: "index_surrogates_on_interface_id"
    t.index ["substitute_id"], name: "index_surrogates_on_substitute_id"
  end

  create_table "tasks", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "configuration_id", null: false
    t.string "name", null: false
    t.integer "minimum", default: 0, null: false
    t.integer "maximum", default: 0, null: false
    t.integer "memory", default: 1024, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["configuration_id"], name: "index_tasks_on_configuration_id"
  end

  create_table "users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "external_id"
    t.string "salutation"
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "appointments", "roles"
  add_foreign_key "builds", "services"
  add_foreign_key "configurations", "builds"
  add_foreign_key "dependencies", "builds"
  add_foreign_key "dependencies", "interfaces"
  add_foreign_key "exposures", "builds"
  add_foreign_key "exposures", "interfaces"
  add_foreign_key "identities", "identity_providers"
  add_foreign_key "identities", "users"
  add_foreign_key "images", "screenshots", on_delete: :cascade
  add_foreign_key "instances", "builds"
  add_foreign_key "instances", "platforms"
  add_foreign_key "json_web_tokens", "identities"
  add_foreign_key "logos", "services", on_delete: :cascade
  add_foreign_key "members", "groups"
  add_foreign_key "members", "users"
  add_foreign_key "parameters", "exposures"
  add_foreign_key "platforms", "users"
  add_foreign_key "screenshots", "services"
  add_foreign_key "services", "users"
  add_foreign_key "surrogates", "interfaces"
  add_foreign_key "surrogates", "interfaces", column: "substitute_id"
  add_foreign_key "tasks", "configurations"
end
