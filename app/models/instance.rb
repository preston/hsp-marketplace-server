class Instance < ApplicationRecord
    belongs_to	:platform
    belongs_to	:build

    validates_presence_of :platform
    validates_presence_of :build
end
