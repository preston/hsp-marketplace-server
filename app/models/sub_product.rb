class SubProduct < ApplicationRecord

	belongs_to	:parent,	class_name: 'Product' #,	foreign_key: :parent_id,	primary_key: :id
	belongs_to	:child,		class_name: 'Product' #,	foreign_key: :child_id,		primary_key: :id

	validates_presence_of	:parent
	validates_presence_of	:child

	validates_uniqueness_of	:parent_id,	scope: [:child_id]

end
