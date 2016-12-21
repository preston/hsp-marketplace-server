class Member < ActiveRecord::Base

    belongs_to	:user
    belongs_to	:group

    validates_presence_of	:user
    validates_presence_of	:group

    validates_uniqueness_of	:user_id,	scope: [:group_id]
end
