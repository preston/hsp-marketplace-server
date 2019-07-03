class Build < ApplicationRecord
    belongs_to	:product

    has_many	:instances,			dependent: :destroy
    has_many	:exposures,			dependent: :destroy
    has_many	:dependencies,		dependent: :destroy
    has_many	:configurations,	dependent: :destroy

    validates_presence_of	:version
    validates_presence_of	:product_version
    validates_presence_of	:container_tag
    validates_presence_of	:container_repository

end
