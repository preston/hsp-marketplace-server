class Appointment < ActiveRecord::Base

	belongs_to	:entity,	polymorphic: true
	belongs_to	:role

	validates_presence_of	:entity
	validates_presence_of	:role

	validates_uniqueness_of :entity_id, scope: [:role_id]

end
