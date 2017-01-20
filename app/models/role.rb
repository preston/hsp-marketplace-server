class Role < ActiveRecord::Base
    has_many	:appointments,	dependent: :destroy
    has_many	:users, source_type: 'User',	as: :entity, through: :appointments,	source: :entity
    has_many	:groups, source_type: 'Group',	as: :entity, through: :appointments,	source: :entity

    validates_presence_of	:name

    validates_uniqueness_of	:name

    validates_inclusion_of :default, in: [true, false]

    validates_with	PermissionsValidator

    after_create	:appoint_to_users

    def appoint_to_users
        if default
            User.all.each do |user|
                Appointment.create!(entity: user, role: self)
            end
        end
    end

    def merge_permissions_of(other)
        self.permissions = Role.merge_other_permissions_into_template(permissions, Role.permissions_template) # Just in case the existing structure doesn't conform to the schema.
        self.permissions = Role.merge_other_permissions_into_template(other, permissions)
    end

    def self.permissions_template
        {
            everything: {
                manage: false
            },
            users: {
                create: false,
                read: false,
                update: false,
                delete: false,
                update_self: false,
                read_self: false
            },
            groups: {
                create: false,
                read: false,
                update: false,
                delete: false
            },
            services: {
                create: false,
                read: false,
                update: false,
                delete: false
            }
        }.deep_stringify_keys!
    end

    # This is somewhat similar to Hash # deep_merge; however, only permissions explicity declared in the template
    # will be copied from the 'other' Hash. An "associative array of associative arrays" schema is required, with
    # extraneous crap being ignored. All keys of the source Hashes will be stringified during execution.
    def self.merge_other_permissions_into_template(other, template)
        return template if !other.is_a?(Hash) || !template.is_a?(Hash)
        template.deep_stringify_keys!
        other.deep_stringify_keys!
        template.each do |resource, settings|
            settings.each do |verb, _value|
                if template.dig(resource, verb).nil?
                # The template doesn't define it, so ignore the value.
                elsif other[resource].is_a?(Hash)
                    # byebug
                    if other.dig(resource, verb).nil?
                    # The 'other' structure doesn't define it. Oh well.
                    elsif [true, false].include?(other[resource][verb]) # it's actually a boolean
                        template[resource][verb] = other[resource][verb] # True always overrides false!
                       end
                end
            end
        end
        template
    end
end
