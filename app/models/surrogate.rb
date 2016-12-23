class Surrogate < ApplicationRecord
	belongs_to	:interface
	belongs_to	:substitute,	class_name: 'Interface'
end
