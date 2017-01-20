class SessionsController < ApplicationController
    # skip_before_action	:set_identity_from_session!,	except: :destroy
    skip_authorization_check

    before_action :cleanse_session, except: :callback

    def cleanse_session
        session['provider_id'] = nil
    end

    def callback
        if params['code'].nil?
            flash[:warning] = "We couldn't verify your single sign-on identity, sorry. Please try again. If you continue to have issues, try logging out first."
            redirect_to :root
        else
            openid_connect_login
        end
    end

    def openid_connect_login
        provider = IdentityProvider.find(session['provider_id'])
        uri = URI(provider.configuration['token_endpoint'])
        data = {
            code: params['code'],
            grant_type: 	:authorization_code,
            client_id: 	provider.client_id,
            client_secret: 	provider.client_secret,
            redirect_uri:	callback_url
            # state: session[:session_id],
            # nonce: new_nonce
        }
        response = Net::HTTP.post_form(uri, data)
        authorization = JSON.parse(response.body)
        logger.debug "Authorization JSON response: #{authorization}"
        jwt = nil
        # byebug
        public_keys_for(provider).each_with_index do |pk, i|
            public_key = OpenSSL::PKey::RSA.new(pk)
            begin
                jwt = JWT.decode(authorization['id_token'], public_key)
                logger.debug("Key #{i} worked!")
                break
            rescue
                # Probably the wrong key.
                # logger.debug("Key #{i} didin't work.")
                next
            end
        end
        # byebug
        msg = "Hmm.. #{provider.name} didn't return what we expected, so we are playing it safe and not authenticating you. Sorry!"
        if jwt.nil?
            redirect_to	:login, message: "#{msg} (Couldn't decrypt token with known public keys.)"
        elsif jwt[0]['aud'] != provider.client_id && jwt[0]['aud'] != provider.alternate_client_id
            flash[:error] = "#{msg} (Provider mismatch.)"
            # redirect_to :login
			render json: {message: 'Error processingn login response. Sorry!'} # FIXME Report error to the user!
        # elsif authorization['state'] != session[:session_id]
        # 	flash[:error] = "#{msg} (Session ID mismatch.)"
        # 	render 	:sorry
        else
            # Looks good!
            # logger.debug jwt
            session['expires_at'] = DateTime.strptime(jwt[0]['exp'].to_s, '%s')
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
            session['identity_id'] = identity.id
            jwt = JsonWebToken.new(identity_id: identity.id, expires_at: 24.hours.from_now)
            jwt.save!
            redirect_to ENV['MARKETPLACE_UI_URL']
        end
    end

    # Some OpenID Connect IDP change their encryption keys frequently. For example, Google rotates daily:
    #
    # 	https://developers.google.com/identity/protocols/OpenIDConnect?hl=en
    #
    # To assure we always have current copies of the public keys, we'll force hourly reconfiguration.
    def public_keys_for(provider)
        if provider.updated_at < 1.hour.ago
            logger.debug 'Forcing IDP reconfiguration to update public keys.'
            provider.reconfigure
            provider.save
        else
            logger.debug 'Using existing public keys.'
        end
        provider.public_keys
    end

    def authenticate
        idp = IdentityProvider.find(params['provider_id'])
		redirect_to_identity_provider(idp)
    end

    def destroy
        unauthenticate!
        render json: {message: 'Logged out.'}, status: :ok
    end
end
