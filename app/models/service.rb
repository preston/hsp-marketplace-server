class Service < ApplicationRecord

	belongs_to	:user
	belongs_to	:license
	has_many	:builds,	dependent: :destroy

	validates_presence_of	:name
	validates_uniqueness_of	:name

end
