class Exposure < ApplicationRecord
	belongs_to	:build
	belongs_to	:interface

	has_many	:parameters,	dependent: :destroy

	validates_presence_of	:build
	validates_presence_of	:interface
end
