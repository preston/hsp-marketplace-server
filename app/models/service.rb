class Service < ApplicationRecord
    include PgSearch
    pg_search_scope :search_by_name_or_description, against: [:name, :description], using: {
        #    trigram: {},
        tsearch: { prefix: true } # Partial words
    }

    # Paperclip
    has_attached_file :logo, styles: { large: '400x400>', medium: '200x200>', small: '100x100>' }, default_url: '/images/:style/missing.png'
    validates_attachment :logo, presence: true,
                                storage: :database,
                                content_type: { content_type: /\Aimage\/.*\z/ },
                                size: { in: 0..8.megabytes }

    belongs_to	:license
    belongs_to	:user
    has_many	:builds,	dependent: :destroy
    has_many	:screenshots,	dependent: :destroy

    validates_presence_of	:name
    validates_presence_of	:license
    validates_presence_of	:user
    validates_uniqueness_of	:name
end
