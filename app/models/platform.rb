class Platform < ApplicationRecord
    belongs_to	:user

    has_many	:instances,	dependent: :destroy

    validates_presence_of	:name
    validates_presence_of	:user

    validates_uniqueness_of	:name, scope: [:user_id]
end
