class Group < ActiveRecord::Base

	has_many	:members,	dependent: :destroy
	has_and_belongs_to_many	:users,	join_table: :members

	has_many	:appointments,	as: :entity,	dependent: :destroy

	validates_presence_of	:name
	validates_uniqueness_of	:name

end
