class Attempt < ApplicationRecord

    belongs_to	:product
    belongs_to	:claim
    belongs_to	:claimant,	polymorphic: true

    validates_presence_of	:product
    validates_presence_of	:claimant_id
    validates_presence_of	:claimant_type
end
