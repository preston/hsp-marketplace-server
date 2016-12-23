class Build < ApplicationRecord
    belongs_to	:service

    has_many	:instances,			dependent: :destroy
    has_many	:exposures,			dependent: :destroy
    has_many	:dependencies,		dependent: :destroy
    has_many	:configurations,	dependent: :destroy
    has_many	:screenshots,		dependent: :destroy

    validates_presence_of	:version
    validates_presence_of	:service_version
    validates_presence_of	:container_tag
    validates_presence_of	:container_respository_url

end
