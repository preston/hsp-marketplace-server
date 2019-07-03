class Voucher < ApplicationRecord

	belongs_to	:redeemer,	class_name: 'User',	foreign_key: :redeemed_by
	belongs_to	:entitlement
	belongs_to	:product_license

	validates_presence_of	:code
	validates_presence_of	:product_license
	# validates_presence_of	:issued_at


end
