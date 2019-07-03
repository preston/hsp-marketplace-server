class AuthorizationsController < ApplicationController

	# skip_before_action :authenticate_user!

	NO_VALID_ENTITLEMENTS = 'No currently-valid entitlements are available for authorization.'

	def requester_role_product
		product = Product.find_by_id(params[:product_id])
		if product
			# authorize! :index, User # HACK: Because index'ing is limited to privileged role types.
			authorize! :authorize, product # HACK: Because index'ing is limited to privileged role types.
			create_attempt(current_user, product, nil)
			render status: :ok
		else
			render json: {message: 'Product not found. Double check your UUID?'}, status: 404 # not found
		end
	end

	def group_product
		group = Group.find_by_id(params[:group_id])
		product = Product.find_by_id(params[:product_id])
		if group && product
			# authorize! :index, group # HACK: Because index'ing is limited to privileged role types.
			authorize! :authorize, product
			products = product.implicit_parents # handles recursion and cyclic graphs for us
			products << product

			# We need find any existing claim records.
			# We'll use our own time to avoid database compatibility issues,
			# and deal with license validation in memory.
			now = Time.now
			claims = ClaimsGroup.joins(:group, entitlement: [product_license: [:product, :license]]).where(
				'entitlements.valid_from < ? AND groups.id = ? AND products.id IN (?)',
				now,
				group.id,
				products.collect{|p| p.id})
			# puts "CONS: #{claims}"
			# byebug
			if authorize_currently_valid(claims, now)
				@claims_group = @claim
				render 'claims_groups/show', status: :ok
			else
				render json: {message: NO_VALID_ENTITLEMENTS}, status: 422 # Unprocessable Entity
			end
			create_attempt(group, product, @claim)
		else
			render json: {message: 'Group or product not found. Double check your UUIDs?'}, status: 404 # not found
		end
	end

	def user_product
		user = User.includes(:groups).find_by_id(params[:user_id])
		product = Product.find_by_id(params[:product_id])
		if user && product
			# authorize! :index, user # HACK: Because index'ing is limited to privileged role types.
			authorize! :authorize, product

			products = product.implicit_parents # handles recursion and cyclic graphs for us
			products << product

			# We need find any existing claim records.
			# We'll use our own time to avoid database compatibility issues,
			# and deal with license validation in memory.
			now = Time.now
			claims = ClaimsUser.joins(:user, entitlement: [:owner, product_license: [:product, :license]]).where(
				'entitlements.valid_from < ? AND users.id = ? AND products.id IN (?)',
				now,
				user,
				products.collect{|p| p.id})
			if authorize_currently_valid(claims, now)
				# We've already authorized against a user claim and rendered.
				@claims_user = @claim
				render 'claims_users/show', status: :ok
			else # try groups, instead!
				claims = ClaimsGroup.joins(:group, entitlement: [:owner, product_license: [:product, :license]]).where(
					'entitlements.valid_from < ? AND groups.id IN (?) AND products.id IN (?)',
					now,
					user.groups.collect{|g| g.id},
					products.collect{|p| p.id})
				if authorize_currently_valid(claims, now)
					@claims_group = @claim
					render 'claims_groups/show', status: :ok
				else
					render json: {message: NO_VALID_ENTITLEMENTS}, status: 422 # Unprocessable Entity
				end
			end
			create_attempt(user, product, @claim)
		else
			render json: {message: 'User or product not found. Double check your UUIDs?'}, status: 404 # not found
		end
	end

	def authorize_currently_valid(claims, now)
		@claim = nil
		not_found = {message: 'No valid user or group claim right exists. Are you sure one exists?'}
		if claims.empty?
			return nil
		else
			# We already have the domain model loaded, so we shouldn't have any N+1 issues.
			# License types vary, so let's make sure we have a valid one.
			claims.each do |c|
				@claim = claim_active?(c, now)
				break if @claim
			end
			if @claim
				authorize_claim!(@claim, now)
				logger.debug "Authorized #{@claim.entity.name.downcase} #{@claim.entity.id} for product #{params[:product_id]}."
			else
				logger.debug "Couldn't find valid claim for product #{params[:product_id]}."
			end
		end
		@claim
	end


	def authorize_claim!(c, time)
		c.update!(
			authorization_count: c.authorization_count + 1,
			authorized_at: time)
	end

	def claim_active?(c, time)
		found = nil
		license = c.entitlement.product_license.license
		# byebug
		case license.expiry
		when License::EXPIRY_INDEFINITE
			found = c # because we don't care about the date
		when License::EXPIRY_RELATIVE
			# byebug
			if c.entitlement.valid_from + license.days_valid.days > time # it hasn't expired yet!
				found = c
			end
		when License::EXPIRY_ABSOLUTE
			# byebug
			if license.expires_at > time # it hasn't expired yet!
				found = c
			end
		end
		found
	end

	def create_attempt(claimant, product, claim)
		Attempt.create!(claimant: claimant, product: product, claim: claim)
	end

end
