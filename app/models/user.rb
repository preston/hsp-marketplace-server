class User < ActiveRecord::Base
    include PgSearch
    # pg_search_scope :search_by_name, :against => :name
    pg_search_scope :search_by_name, against: [:name], using: {
        #   trigram: {},
        tsearch: { prefix: true }
    }

    has_many	:memberships,	class_name: 'Member',	dependent: :destroy
    has_and_belongs_to_many	:groups,	join_table: :members

    has_many	:appointments,	class_name: 'Appointment',	as: :entity,	dependent: :destroy
    has_many	:roles,	class_name: 'Role',	through: :individual_appointments,	source: :role

    has_many	:identities, dependent: :destroy
    has_many	:platforms, dependent: :destroy
    has_many	:services,	dependent: :destroy

    validates_presence_of :name

    after_create	:appoint_default_roles

    def appoint_default_roles
        Role.where(default: true).each do |role|
            Appointment.create!(entity: self, role: role)
        end
    end

    # Permissions aggregation function. Eager load everything before calling this.
    def permissions
        perms = {}
        appointments.each do |a|
            a.role.permissions.each do |resource, verbs|
                perms[resource] = {} if perms[resource].nil?
                verbs.each do |verb, value|
                    if perms[resource][verb].nil?
                        perms[resource][verb] = value
                    else
                        perms[resource][verb] |= value # True overrides false!
                    end
                end
            end
        end
        perms
        Role.merge_other_permissions_into_template(perms, Role.permissions_template)
    end

end
