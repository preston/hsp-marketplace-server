class Collapse < ActiveRecord::Migration[6.1]
  def change

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.uuid "record_id", null: false
    t.string "record_type", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "appointments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "entity_id", null: false
    t.string "entity_type", null: false
    t.uuid "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id", "role_id"], name: "index_appointments_on_entity_id_and_role_id"
    t.index ["entity_id"], name: "index_appointments_on_entity_id"
    t.index ["role_id"], name: "index_appointments_on_role_id"
  end

  create_table "attempts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "claim_id"
    t.uuid "claimant_id"
    t.string "claimant_type"
    t.uuid "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "badges", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_badges_on_name", unique: true
  end

  create_table "badges_products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "badge_id", null: false
    t.uuid "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["badge_id", "product_id"], name: "index_badges_products_on_badge_id_and_product_id", unique: true
  end

  create_table "builds", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "product_id", null: false
    t.string "version", null: false
    t.string "container_repository"
    t.string "container_tag"
    t.datetime "validated_at"
    t.datetime "published_at"
    t.json "permissions", default: {}, null: false
    t.text "release_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_builds_on_id"
  end

  create_table "claims", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "claimant_id"
    t.string "claimant_type"
    t.uuid "entitlement_id"
    t.integer "authorization_count"
    t.datetime "authorized_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "configurations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "build_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["build_id"], name: "index_configurations_on_build_id"
  end

  create_table "dependencies", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "build_id", null: false
    t.uuid "interface_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "required", default: true, null: false
    t.json "mappings", default: {}, null: false
    t.index ["build_id"], name: "index_dependencies_on_build_id"
    t.index ["interface_id"], name: "index_dependencies_on_interface_id"
  end

  create_table "entitlements", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "product_license_id"
    t.datetime "valid_from"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "exposures", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "build_id", null: false
    t.uuid "interface_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["build_id"], name: "index_exposures_on_build_id"
    t.index ["interface_id"], name: "index_exposures_on_interface_id"
  end

  create_table "groups", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_groups_on_name"
  end

  create_table "identities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
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

  create_table "identity_providers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
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

  create_table "instances", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "platform_id", null: false
    t.uuid "build_id", null: false
    t.json "launch_bindings", default: {}, null: false
    t.datetime "deployed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["build_id"], name: "index_instances_on_build_id"
    t.index ["platform_id"], name: "index_instances_on_platform_id"
  end

  create_table "interfaces", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "uri", null: false
    t.string "version", null: false
    t.integer "ordinal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "json_web_tokens", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "identity_id", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expires_at"], name: "index_json_web_tokens_on_expires_at"
    t.index ["identity_id"], name: "index_json_web_tokens_on_identity_id"
  end

  create_table "licenses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.integer "expiry"
    t.datetime "expires_at"
    t.integer "days_valid", default: 0
    t.integer "uses", default: 0
    t.string "external_id"
    t.index ["name"], name: "index_licenses_on_name", unique: true
  end

  create_table "members", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "group_id", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_members_on_group_id"
    t.index ["user_id"], name: "index_members_on_user_id"
  end

  create_table "parameters", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "exposure_id", null: false
    t.string "name", null: false
    t.boolean "required"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exposure_id"], name: "index_parameters_on_exposure_id"
  end

  create_table "platforms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.uuid "user_id", null: false
    t.text "public_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_platforms_on_user_id"
  end

  create_table "product_licenses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "product_id"
    t.uuid "license_id"
    t.uuid "external_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.uuid "user_id"
    t.string "uri"
    t.string "support_url"
    t.datetime "published_at"
    t.datetime "visible_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "external_id"
    t.string "locale"
    t.string "mime_type"
    t.index ["name"], name: "index_products_on_name", unique: true
  end

  create_table "roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.boolean "default", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "permissions", default: {}, null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "screenshots", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "caption", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "product_id", null: false
    t.index ["product_id"], name: "index_screenshots_on_product_id"
  end

  create_table "sub_products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "parent_id"
    t.uuid "child_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id", "child_id"], name: "index_sub_products_on_parent_id_and_child_id"
  end

  create_table "surrogates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "interface_id", null: false
    t.uuid "substitute_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["interface_id"], name: "index_surrogates_on_interface_id"
    t.index ["substitute_id"], name: "index_surrogates_on_substitute_id"
  end

  create_table "tasks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "configuration_id", null: false
    t.string "name", null: false
    t.integer "minimum", default: 0, null: false
    t.integer "maximum", default: 0, null: false
    t.integer "memory", default: 1024, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["configuration_id"], name: "index_tasks_on_configuration_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "external_id"
    t.string "salutation"
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vouchers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "product_license_id"
    t.uuid "entitlement_id"
    t.string "code"
    t.datetime "issued_at"
    t.datetime "expires_at"
    t.datetime "redeemed_at"
    t.uuid "redeemed_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "appointments", "roles"
  add_foreign_key "builds", "products"
  add_foreign_key "configurations", "builds"
  add_foreign_key "dependencies", "builds"
  add_foreign_key "dependencies", "interfaces"
  add_foreign_key "exposures", "builds"
  add_foreign_key "exposures", "interfaces"
  add_foreign_key "identities", "identity_providers"
  add_foreign_key "identities", "users"
  add_foreign_key "instances", "builds"
  add_foreign_key "instances", "platforms"
  add_foreign_key "json_web_tokens", "identities"
  add_foreign_key "members", "groups"
  add_foreign_key "members", "users"
  add_foreign_key "parameters", "exposures"
  add_foreign_key "platforms", "users"
  add_foreign_key "products", "users"
  add_foreign_key "screenshots", "products"
  add_foreign_key "surrogates", "interfaces"
  add_foreign_key "surrogates", "interfaces", column: "substitute_id"
  add_foreign_key "tasks", "configurations"
end
end