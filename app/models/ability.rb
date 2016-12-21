class Ability
	include CanCan::Ability

	def initialize(user)
		user ||= User.new # Unauthenticated

		if user.id.nil? # Unauthenticated guest.
			# Nada!
		else # Normal authenticated user.

			# We're going to disable detailed authorization controls for now!
			can :manage, :all
			
			# can :manage, System::User
			#
			# # Identity and Access Management (IAM)
			# can :read,	System::Identity, user_id: user.id
			# can :delete,	System::Identity, user_id: user.id
			# can :read, System::User, id: user.id
			#
			# can :edit, System::User, id: user.id
			#
			# can :read, System::Client
			# can :launch, System::Client

		end
	end
end
