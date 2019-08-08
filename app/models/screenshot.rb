class Screenshot < ApplicationRecord
    belongs_to	:product
    has_one_attached    :image

    validates_presence_of	:product
    validates_presence_of	:caption

    validates_uniqueness_of	:caption, scope: [:product_id]
end
