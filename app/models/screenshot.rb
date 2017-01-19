class Screenshot < ApplicationRecord
    belongs_to	:service

    has_attached_file :image, styles: { large: '1600x1600>', medium: '800x800>', small: '400x400>' }, default_url: '/images/:style/missing.png'
    validates_attachment :image, presence: true,
                                 storage: :database,
                                 content_type: { content_type: /\Aimage\/.*\z/ },
                                 size: { in: 0..8.megabytes }

    validates_presence_of	:service
    validates_presence_of	:caption

    validates_uniqueness_of	:caption, scope: [:service_id]
end
