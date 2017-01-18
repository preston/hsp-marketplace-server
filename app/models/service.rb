class Service < ApplicationRecord

	include PgSearch
	pg_search_scope :search_by_name_or_description, against: [:name, :description], using: {
        #    trigram: {},
        tsearch: { prefix: true } # Partial words
    }

	belongs_to	:license
	belongs_to	:user
	has_many	:builds,	dependent: :destroy

	validates_presence_of	:name
	validates_presence_of	:license
	validates_presence_of	:user
	validates_uniqueness_of	:name

end
