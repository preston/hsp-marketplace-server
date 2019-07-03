class Instance < ApplicationRecord
    belongs_to	:platform
    belongs_to	:build

    validates_presence_of :platform
    validates_presence_of :build

    after_create :notify_create

    def notify_create
        PlatformChannel.broadcast_to self.platform,
            resource_type: 'instance',
           event_type: 'created',
           message: 'A build instance has been added to the platform.',
           model: {
               instance: {
                   build: {
                       id: build.id,
                       container_repository: build.container_repository,
                       container_tag: build.container_tag,
                       product: {
                           id: build.product.id
                       }
                   },
                   platform: {
                       id: platform.id,
                       user: {
                           id: platform.user.id
                       }
                   }
               }
           }
    end

    def force_notify_create
        self.notify_create
    end

end
