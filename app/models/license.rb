class License < ApplicationRecord
    validates_presence_of	:name
    validates_presence_of	:url

    validates_uniqueness_of	:name
    validates_uniqueness_of	:url

    has_many	:services,	dependent: :destroy
end
