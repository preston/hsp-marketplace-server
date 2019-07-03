class ProductLicense < ApplicationRecord

	belongs_to	:product
	belongs_to	:license

	has_many	:entitlements,	dependent: :destroy
	has_many	:vouchers,	dependent: :destroy

	validates_presence_of	:product
	validates_presence_of	:license

	validates_uniqueness_of	:product, scope: [:license_id], message: "cannot be associate with the same license twice."

end
