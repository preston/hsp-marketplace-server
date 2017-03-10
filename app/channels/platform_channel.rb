class PlatformChannel < ApplicationCable::Channel
    def subscribed
        # byebug
        puts "PlatformChannel subscription params: #{params}"
        platform = Platform.find(params[:platform_id])
        stream_for platform if platform
    end

end
