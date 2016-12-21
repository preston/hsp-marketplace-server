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

    validates_presence_of :name
end
