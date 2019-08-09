class License < ApplicationRecord

    has_many	:products,	dependent: :destroy
    has_many	:product_licenses,	dependent: :destroy

	has_and_belongs_to_many	:products, join_table: :product_licenses
    
	has_many	:entitlements
	has_many	:product_licenses,	dependent: :destroy

    validates_presence_of	:name
    validates_presence_of	:url
    validates_uniqueness_of	:url
	validates_presence_of	:expiry
	# validates :expiry, inclusion: {in: License.expiries.keys}
	validates_presence_of	:uses
	validates_numericality_of	:uses, only_integer: true, greater_than_or_equal_to: 0
	validates_presence_of	:days_valid
	validates_numericality_of	:days_valid, only_integer: true, greater_than_or_equal_to: 0

	EXPIRY_INDEFINITE = 'indefinite'
	EXPIRY_RELATIVE = 'relative_date'
	EXPIRY_ABSOLUTE = 'absolute_date'

	enum expiry: {
		EXPIRY_INDEFINITE => 0,
		EXPIRY_RELATIVE => 1,
		EXPIRY_ABSOLUTE => 2
    }

end
