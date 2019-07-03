class Entitlement < ApplicationRecord

    belongs_to	:owner,	class_name: 'User', foreign_key: :user_id
    belongs_to	:product_license

    validates_presence_of	:owner
    validates_presence_of	:product_license
    validates_presence_of	:valid_from

    has_many	:claims,	dependent: :destroy
    has_many	:vouchers,	dependent: :destroy

    has_and_belongs_to_many	:direct_consumers,	class_name: 'User', join_table: :claims_users
    has_and_belongs_to_many	:group_consumers,	class_name: 'Group', join_table: :claims_groups

    # Potentially useful, but unused.
    # def all_consuming_users
    # 	users = self.claims_users.collect{|cu| cu.user}
    # 	self.claims_groups.each do |cg|
    # 		users.concat cg.group.users.all
    # 	end
    # 	users.uniq
    # end

    # def self.destroy_expired!
    # 	expired = Entitlement.joins(:claims_users, :claims_groups).where
    # end
end
