class WelcomeController < ApplicationController

	skip_before_action	:authenticate_identity!, only: [:landing]
	skip_authorization_check

	def landing
		@skip_navigation = true
	end

	def dashboard
	end

	def status
		json = {}
		jwt = request.headers['Authorization']
		if jwt
			if jwt = System::JsonWebToken.decode_authorization(jwt)
				if jwt = System::JsonWebToken.find(jwt['id'])
					activity = Context::Activity.create_default!(jwt.identity.user)
					json.merge!(
						activity: {
							id: activity.id,
							path: activity_path(activity),
							url: activity_url(activity)
						},
						identity: {
							id: jwt.identity.id,
							user: {
								id: jwt.identity.user.id,
								name: jwt.identity.user.name,
								url: user_url(jwt.identity.user),
								path: user_path(jwt.identity.user)
							}
						},
						jwt: {id: jwt.id, encoded: jwt.encode}
					)
				end
			end
		end
		json.merge!(
			message: 'This application server and underlying database connection appear to be healthy.',
			datetime: Time.now)
        render json: json, status: :ok
	end

end
