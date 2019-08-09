class Ability
    include CanCan::Ability

    def initialize(user)
        user ||= User.new # Unauthenticated

        # TODO FIXME: We're going to disable detailed authorization controls for now!!!
        can :manage, :all

        can [:read, :search, :small, :medium, :large], Product do |s| s.published_at ? (s.published_at <= Time.now) : false end
        can [:read, :small, :medium, :large], Screenshot
        can :read, Build
        can :read, Dependency
        can :read, Exposure
        can :read, Configuration
        can :read, Interface
		can :read, License
		can :read, Badge
        can [:read, :redirect], IdentityProvider # Needed for login purposes, but will be filtered at the field level.
        #
        if user.id.nil? # Unauthenticated guest.
            # Nothing additional!
        else # Normal authenticated user.
            if user.permissions.dig('everything', 'manage')
                can :manage, :all # God mode!
                cannot	:destroy, User,	id: user.id	# No suicides for these folks to prevent complete system lockouts.
            else
                # Always grant Identity and Access Management (IAM) right to the current account and owned objects.
                can :read,	Identity, user_id: user.id
                can :delete, Identity, user_id: user.id
                can :read, User, id: user.id

                can :manage, Platform, user_id: user.id
                can :manage, Instance, platform: {user_id: user.id}
            end
        end
    end
end
