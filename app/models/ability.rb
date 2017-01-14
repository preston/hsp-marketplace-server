class Ability
    include CanCan::Ability

    def initialize(user)
        user ||= User.new # Unauthenticated

        # We're going to disable detailed authorization controls for now!
        can :manage, :all

        # can :read, Service do |s| s.visible_at <= Time.now end
        # can :read, Interface do |i| i.published_at <= Time.now end
        # can :read, Build
        # can :read, Exposure
		#
        # if user.id.nil? # Unauthenticated guest.
        # # Nada!
        # else # Normal authenticated user.
		#
        #   # We're going to disable detailed authorization controls for now!
        #   can :manage, :all
		#
        #   # can :manage, User
        #   #
        #   # # Identity and Access Management (IAM)
        #   can :read,	Identity, user_id: user.id
        #   can :delete, Identity, user_id: user.id
        #   can :read, User, id: user.id
		#
        #   can :edit, User, id: user.id
        #     #
        #     # can :read, Client
        #     # can :launch, Client
		#
        # end
    end
end
