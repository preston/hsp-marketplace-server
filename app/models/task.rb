class Task < ApplicationRecord
	belongs_to	:configuration


	validates_presence_of	:configuration
	validates_presence_of	:name
	validates_presence_of	:minimum,	integer_only: true
	validates_presence_of	:maximum,	integer_only: true
	validates_presence_of	:memory,	integer_only: true
end
