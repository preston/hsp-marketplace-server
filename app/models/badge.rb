class Badge < ApplicationRecord

	has_and_belongs_to_many	:badges, join_table: :badges_products

	validates_presence_of	:name
	validates_presence_of	:description

	validates_uniqueness_of	:name
end
