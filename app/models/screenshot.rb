class Screenshot < ApplicationRecord

	belongs_to	:build

	validates_presence_of	:build
	validates_presence_of	:caption
	validates_presence_of	:mime_type
end
