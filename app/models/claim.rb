class Claim < ApplicationRecord

	belongs_to	:claimant,	polymorphic: true
	belongs_to	:entitlement

	has_many	:attempts

	validates_presence_of	:claimant
	validates_presence_of	:entitlement

end
