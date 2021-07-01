class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # Unauthenticated

    # TODO: FIXME: We're going to disable detailed authorization controls for now!!!
    # can :manage, :all
# puts "CANCAN"
    can [:read, :search, :small, :medium, :large], Product do |s|
      s.published_at && s.published_at <= Time.now &&
        s.visible_at && s.visible_at <= Time.now
    end
    can %i[read small medium large], Screenshot
    can :read, Build
    can :read, Dependency
    can :read, Exposure
    can :read, Configuration
    can :read, Interface
    can :read, License
    can :read, Badge
    can %i[read redirect], IdentityProvider # Needed for login purposes, but will be filtered at the field level.
    #
    if user.id.nil? # Unauthenticated guest.
    # Nothing additional!
    elsif user.permissions.dig('everything', 'manage') # Normal authenticated user.
        # puts "ADMINISTRATOR"
      can :manage, :all # God mode!
      cannot	:destroy, User,	id: user.id
    else
        # puts user.permissions.dig('products', 'delete')
      can :create, Product if user.permissions.dig('products', 'create')
      can :read, Product if user.permissions.dig('products', 'read')
      can :read, Product, user_id: user.id
      can :update, Product if user.permissions.dig('products', 'update')
      can :destroy, Product if user.permissions.dig('products', 'delete')
      # Always grant Identity and Access Management (IAM) right to the current account and owned objects.
      can :read,	Identity, user_id: user.id
      can :delete, Identity, user_id: user.id
      can :read, User, id: user.id

      can :manage, Platform, user_id: user.id
      can :manage, Instance, platform: { user_id: user.id }
    end
  end
end
