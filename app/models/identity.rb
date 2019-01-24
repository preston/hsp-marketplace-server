class Identity < ActiveRecord::Base

	belongs_to	:user
	belongs_to	:identity_provider

	has_many	:json_web_tokens,	dependent: :destroy

	validates_presence_of	:user
	validates_presence_of	:identity_provider
	validates_presence_of	:sub

	validates_uniqueness_of	:sub, scope: [:identity_provider_id]

end
