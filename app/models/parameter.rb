class Parameter < ApplicationRecord

	belongs_to	:exposure

	validates_presence_of	:exposure
	validates_presence_of	:name

end
