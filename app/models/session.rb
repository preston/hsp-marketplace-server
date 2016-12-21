class Session < ActiveRecord::Base

	belongs_to	:identity

	validates_presence_of	:identity

end
