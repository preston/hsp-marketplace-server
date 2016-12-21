class Collapse < ActiveRecord::Migration
    def change
        enable_extension 'uuid-ossp'

        create_table 'appointments', id: :uuid do |t|
            t.uuid     'entity_id', null: false
            t.string   'entity_type', null: false
            t.uuid     'role_id',     null: false
            t.datetime 'created_at',  null: false
            t.datetime 'updated_at',  null: false
        end

        add_index 'appointments', %w(entity_id role_id)
        add_index 'appointments', ['entity_id']
        add_index 'appointments', ['role_id']

        create_table 'clients', id: :uuid do |t|
            t.string   'name',       null: false
            t.string   'launch_url', null: false
            t.string   'icon_url'
            t.boolean  'available',  null: false
            t.datetime 'created_at', null: false
            t.datetime 'updated_at', null: false
        end

        add_index 'clients', ['name'], unique: true

        create_table 'groups', id: :uuid do |t|
            t.string   'name', null: false
            t.text     'description'
            t.datetime 'created_at',  null: false
            t.datetime 'updated_at',  null: false
        end

        add_index 'groups', ['name']

        create_table 'identities', id: :uuid do |t|
            t.uuid     'user_id', null: false
            t.uuid     'identity_provider_id', null: false
            t.string   'sub', null: false
            t.string   'iat'
            t.string   'hd'
            t.string   'locale'
            t.string   'email'
            t.json     'jwt',              default: {},    null: false
            t.boolean  'notify_via_email', default: false, null: false
            t.boolean  'notify_via_sms',   default: false, null: false
            t.datetime 'created_at',                       null: false
            t.datetime 'updated_at',                       null: false
        end

        create_table 'identity_providers', id: :uuid do |t|
            t.string   'name',                             null: false
            t.string   'issuer',                           null: false
            t.string   'client_id',                        null: false
            t.string   'client_secret',                    null: false
            t.string   'alternate_client_id'
            t.json     'configuration'
            t.json     'public_keys'
            t.datetime 'created_at',                       null: false
            t.datetime 'updated_at',                       null: false
            t.string   'scopes', default: '', null: false
        end

        add_index 'identity_providers', ['name']

        create_table 'json_web_tokens', id: :uuid do |t|
            t.uuid     'identity_id', null: false
            t.datetime 'expires_at',  null: false
            t.datetime 'created_at',  null: false
            t.datetime 'updated_at',  null: false
        end

        add_index 'json_web_tokens', ['expires_at']
        add_index 'json_web_tokens', ['identity_id']

        create_table 'members', id: :uuid do |t|
            t.uuid     'group_id', null: false
            t.uuid     'user_id',  null: false
            t.datetime 'created_at', null: false
            t.datetime 'updated_at', null: false
        end

        add_index 'members', ['group_id']
        add_index 'members', ['user_id']

        create_table 'users', id: :uuid do |t|
            t.string   'name', null: false
            t.string   'external_id'
            t.string   'salutation'
            t.string   'first_name'
            t.string   'middle_name'
            t.string   'last_name'
            t.datetime 'created_at',  null: false
            t.datetime 'updated_at',  null: false
        end

        create_table 'roles', id: :uuid do |t|
            t.string   'name',        null: false
            t.string   'code',        null: false
            t.text     'description'
            t.datetime 'created_at',  null: false
            t.datetime 'updated_at',  null: false
        end

        add_index 'roles', ['code'], name: 'index_roles_on_code', unique: true
        add_index 'roles', ['name'], name: 'index_roles_on_name', unique: true

        create_table 'sessions', id: :uuid do |t|
            t.uuid     'identity_id', null: false
            t.datetime 'expires_at'
            t.datetime 'created_at',  null: false
            t.datetime 'updated_at',  null: false
        end

        add_foreign_key 'appointments', 'roles'
        add_foreign_key 'identities', 'identity_providers'
        add_foreign_key 'identities', 'users'
        add_foreign_key 'json_web_tokens', 'identities'
        add_foreign_key 'members', 'groups'
        add_foreign_key 'members', 'users'
  end
end
