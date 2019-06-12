class SessionsController < ApplicationController
    # skip_before_action	:set_identity_from_session!,	except: :destroy
    skip_authorization_check

    before_action :cleanse_session, except: :callback

    def cleanse_session
        session['provider_id'] = nil
        cookies.signed['identity_id'] = nil
    end

    def callback
        if params['code'].nil?
            # @flash[:warning] =
            Rails.logger.error "We couldn't verify your single sign-on identity, sorry. Please try again. If you continue to have issues, try logging out first."
            # redirect_to :root
            redirect_to ENV['MARKETPLACE_UI_URL']
        else
            openid_connect_login
        end
    end

    def openid_connect_login
        # provider = IdentityProvider.find(session['provider_id'])
		provider_id = JSON.parse(Base64.decode64(params['state']))['provider_id']
	    provider = IdentityProvider.find(provider_id)
        uri = URI(provider.configuration['token_endpoint'])
        data = {
            client_id: 	provider.client_id,
            code: params['code'],
            grant_type: 	:authorization_code,
            client_secret: 	provider.client_secret
            # redirect_uri:	callback_url
            # state: session[:session_id],
            # nonce: new_nonce
        }
        puts uri.to_s
        response = Net::HTTP.post_form(uri, data)
        authorization = JSON.parse(response.body)
        logger.debug "Authorization JSON response: #{authorization}"
        # Decode the JWT first.
        jwt = JWT.decode(authorization['access_token'], nil, false)
        Rails.logger.debug "JWT decoded data: #{jwt}"
        alg = jwt[-1]['alg']
        # byebug
        # Now verify the JWT is legit.
        verified = nil
        public_keys_for(provider).each_with_index do |pk, i|
            # byebug
            public_key = OpenSSL::PKey::RSA.new(pk)
            begin
                jwt = JWT.decode(authorization['access_token'], public_key, true, {algorithm: alg})
                logger.debug("Key #{i} worked!")
                verified = true
                break
            rescue
                # Probably the wrong key.
                # logger.debug("Key #{i} didin't work.")
                next
            end
        end
        msg = "Hmm.. #{provider.name} didn't return what we expected, so we are playing it safe and not authenticating you. Sorry!"
        # byebug
        if !verified
            redirect_to	:login, message: "#{msg} (Couldn't decrypt token with known public keys.)"
        elsif jwt[0]['azp'] != provider.client_id && jwt[0]['azp'] != provider.alternate_client_id
            # @flash[:error] = 
            Rails.logger.error "#{msg} (Provider mismatch.)"
            # redirect_to :login
			render json: {message: 'Error processing login response. Sorry!'} # FIXME Report error to the user!
        # elsif authorization['state'] != session[:session_id]
        # 	@flash[:error] = "#{msg} (Session ID mismatch.)"
        # 	render 	:sorry
        else
            # Looks good!
            # logger.debug jwt
            # session['expires_at'] = DateTime.strptime(jwt[0]['exp'].to_s, '%s')
            subject = jwt[0]['sub']
            # byebug
            identity = Identity.where(sub: subject, identity_provider: provider).first
            email = jwt[0]['email']
            if identity.nil?
                user = current_user
                if user.nil? # The user is not logged in.
                    user = User.create!(
                        name: jwt[0]['name'],
                        first_name: jwt[0]['given_name'],
                        last_name: jwt[0]['family_name']
                    )
                end

                identity = Identity.create!(
                    user: user,
                    identity_provider: provider,
                    sub: subject,
                    iat: jwt[0]['iat'],
                    hd: jwt[0]['hd'],
                    locale: jwt[0]['locale'],
                    email: email,
                    jwt: jwt[0]
                )
            else
                identity.user.update(
                    name: jwt[0]['name'],
                    first_name: jwt[0]['given_name'],
                    last_name: jwt[0]['family_name']
                )
            end
            # session['identity_id'] = identity.id
            # cookies.signed['identity_id'] = session['identity_id']
            jwt = JsonWebToken.new(identity_id: identity.id, expires_at: 24.hours.from_now)
            jwt.save!
            redirect_to ENV['MARKETPLACE_UI_URL'] + "\?jwt=#{jwt.encode}"
        end
    end

    # Some OpenID Connect IDP change their encryption keys frequently. For example, Google rotates daily:
    #
    # 	https://developers.google.com/identity/protocols/OpenIDConnect?hl=en
    #
    # To assure we always have current copies of the public keys, we'll force hourly reconfiguration.
    def public_keys_for(provider)
        if provider.updated_at < 15.minutes.ago
            logger.debug 'Forcing IDP reconfiguration to update public keys.'
            provider.reconfigure
            provider.save
        else
            logger.debug 'Using existing public keys.'
        end
        provider.public_keys
    end

    # def authenticate
    #     idp = IdentityProvider.find(params['provider_id'])
	# 	redirect_to_identity_provider(idp)
    # end

    def destroy
        unauthenticate!
        render json: {message: 'Logged out.'}, status: :ok
    end
end
