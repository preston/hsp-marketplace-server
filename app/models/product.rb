class Product < ApplicationRecord

	include PgSearch::Model
    pg_search_scope :search_by_name_or_description, against: [:name, :description], using: {
        #    trigram: {},
        tsearch: { prefix: true } # Partial words
    }

    has_one_attached    :logo

    belongs_to	:user
    has_many	:builds,	dependent: :destroy
    has_many	:screenshots,	dependent: :destroy
	has_many	:product_licenses,	dependent: :destroy
    has_and_belongs_to_many	:licenses, join_table: :product_licenses

    has_many	:children_relations,	class_name: 'SubProduct',	foreign_key: :parent_id, dependent: :destroy
    has_many	:parent_relations,		class_name: 'SubProduct',	foreign_key: :child_id, dependent: :destroy
    has_many	:children,	through: :children_relations
    has_many	:parents,	through: :parent_relations

    validates_presence_of	:name
    validates_presence_of	:user
	validates_uniqueness_of	:name
	
	def implicit_parents(all = [])
        # It's faster to do this with database "WITH RECURSIVE",
        # but we'll stick to the application layer for now to avoid potential compatibilty issues.
        parents.each do |p|
            if all.include? p # We have a cyclic graph and should skip to prevent infinite recursion.
                next
            else
                all << p
                p.implicit_parents(all) # recursion
                all.flatten!
            end
        end
        all.uniq!
        all
    end

    def implicit_children(all = [])
        # It's faster to do this with database "WITH RECURSIVE",
        # but we'll stick to the application layer for now to avoid potential compatibilty issues.
        children.each do |c|
            if all.include? c # We have a cyclic graph and should skip to prevent infinite recursion.
                next
            else
                all << c
                c.implicit_children(all) # recursion
                all.flatten!
            end
        end
        all.uniq!
        all
	end
	
end
