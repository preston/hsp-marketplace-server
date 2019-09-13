class Build < ApplicationRecord
    belongs_to	:product
    has_one_attached    :asset

    has_many	:instances,			dependent: :destroy
    has_many	:exposures,			dependent: :destroy
    has_many	:dependencies,		dependent: :destroy
    has_many	:configurations,	dependent: :destroy

    validates_presence_of	:version

    validates_uniqueness_of :version, scope: [:product_id]
end
