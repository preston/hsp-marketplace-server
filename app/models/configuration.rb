class Configuration < ApplicationRecord
	belongs_to	:build
	has_many	:tasks,	dependent: :destroy

	validates_presence_of	:build
	validates_presence_of	:name
end
