class Instance < ApplicationRecord
    belongs_to	:platform
    belongs_to	:build

    validates_presence_of :platform
    validates_presence_of :build

    after_create    :notify_create

    def notify_create
        PlatformChannel.broadcast_to self.platform, {
            resource_type: 'instance',
            event_type: "created",
            message: 'A build instance has been added to the platform.',
            model: {
                build: {
                    id: self.build.id,
                    container_repository: self.build.container_repository,
                    container_tag: self.build.container_tag,
                    service: {
                        id: self.build.service.id
                    }
                },
                platform: {
                    id: self.platform.id,
                    user: {
                        id: self.platform.user.id
                    }
                }
            }
        }
    end
end
