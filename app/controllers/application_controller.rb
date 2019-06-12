class ApplicationController < ActionController::Base
    include CanCan::ControllerAdditions

    # Short-circuit any/all CORS pre-flight OPTIONS requests.
    # before_action :cors_preflight_check

    # Allow the browser to make CORS requests since we do not provide a UI.
    # This is expected and totally cool, so long as subsequent requests are encrypted and include either
    # a tamper-proof cookie or JWT.
    # after_action :cors_set_access_control_headers

    # Assure that CanCanCan authorization checks run.
    # check_authorization

    # before_action :set_identity_from_session!
    before_action :set_identity_from_jwt!

    # def set_options_from(request)
    #     @options = {}
    #     request.body.split(/&/).each do |param|
    #         key, val = param.split('=').map { |v| CGI.unescape(v) }
    #         @options[key] = val
    #     end
    # end

	# MARKETPLACE_UI_URL = ENV['MARKETPLACE_UI_URL']

    # Return the CORS access control headers.
    # def cors_set_access_control_headers
    #     headers['Access-Control-Allow-Origin'] = '*' #ENV['MARKETPLACE_UI_URL']
	# 	headers['Access-Control-Allow-Credentials'] = 'true'
    #     headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS, PUT, PATCH, DELETE'
    #     headers['Access-Control-Allow-Headers'] = 'Authorization'
    #     # headers['Access-Control-Max-Age'] = '1728000'
    # end

    # If this is a preflight OPTIONS request, then short-circuit the
    # request, return only the necessary headers and return an empty
    # text/plain.
    # def cors_preflight_check
    #     if request.method.to_sym.downcase == :options
    #         headers['Access-Control-Allow-Origin'] = '*' #ENV['MARKETPLACE_UI_URL']
	# 		headers['Access-Control-Allow-Credentials'] = true
    #         headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS, PUT, PATCH, DELETE'
    #         headers['Access-Control-Allow-Headers'] = 'Authorization, Content-Type'
    #         headers['Access-Control-Max-Age'] = '1728000'
    #         render plain: '', content_type: 'text/plain'
    #     end
    # end

    rescue_from CanCan::AccessDenied do |exception|
        Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
        render json: {message: 'You are not authorized, sorry!'}, status: :unauthorized
    end

    # CanCanCan's authorization
    # rescue_from CanCan::AccessDenied do |exception|
    #     # byebug
    #     Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    #     flash[:error] = exception.message
    #     redirect_to root_url
    # end

    # We'll completely disable authentication for now!
    def set_identity_from_jwt!
        identity_id = nil
        if authorization = request.headers['Authorization']
            json = JsonWebToken.decode_authorization(authorization)
			if json
				begin
            		jwt = JsonWebToken.find(json['id'])
            		identity_id = jwt.identity_id
				rescue Exception => e
					Rails.logger.warn "JWT #{json['id']} couldn't be found. It may have been deleted or a client may be misbehaving."
				end
			end
        end
        if identity_id.nil?
            # respond_to do |format|
                # format.json { render json: { message: 'Invalid or expired JWT. Please (re)authenticate and sign your request properly!' }, status: :unauthorized }
                # format.html { redirect_to landing_path, notice: 'Unable to authenticate your identity. Please log in again.' }
            # end
        else
            begin
                @current_identity = Identity.find(identity_id)
                @current_user = @current_identity.user
            rescue Exception => e
        		Rails.logger.warn 'Claimed identity not found. User may be have been deleted? Removing identity from session!'
        		Rails.logger.warn e
            end
        end
        # @current_user
		@current_identity
    end

    def unauthenticate!
        session[:identity_id] = nil
        @current_user = nil
        @current_identity = nil
    end

    attr_reader :current_user
    # 'current_user' needs to be defined for cancancan
    # alias current_user current_user

    # attr_reader :current_identity

    # def new_nonce
    #     session[:nonce] = SecureRandom.hex(16)
    # end

    # def stored_nonce
    #     session.delete(:nonce)
    # end

    def redirect_to_identity_provider(provider)
        # session['provider_id'] = provider.id
		# session['referer_url'] = request.referer
        uri = URI(provider.configuration['authorization_endpoint'])
        query = {
            client_id: 		provider.client_id,
            response_type: 	:code,
            # redirect_uri:	callback_url,
            scope: provider.scopes,
			state: Base64.encode64({
				provider_id: provider.id
			}.to_json),
	        # redirect_uri:	ENV['MARKETPLACE_UI_URL']
            # state: 			new_nonce,
            # prompt: :login,
            access_type: 	:offline,
            aud: provider.client_id
        }
        uri.query = URI.encode_www_form(query)
        # byebug
        # redirect_to uri.to_s
        s = URI.unescape(uri.to_s)
        Rails.logger.info("Redirecting SSO login to: #{s}")
        redirect_to s
    end

    def build_oauth_request(tool, uri, options)
        # The OAuth::Consumer is finicky about port specification.
        host = if uri.port == uri.default_port
                   uri.host
               else
                   "#{uri.host}:#{uri.port}"
               end
        consumer = OAuth::Consumer.new(
            tool.key,
            tool.secret,
            site: "#{uri.scheme}://#{host}",
            signature_method: options['oauth_signature_method']
        )

        path = uri.path
        path = '/' if path.empty?
        if uri.query_values # && uri.query != ''
            uri.query_values.each do |k, v|
                next if options[k]
                options[k] = v.first
                # options[k] = URI.escape(v.first)
                options["custom_#{k}"] = v.first
            end
        end
        # uri.query = nil

        # Note the use of the "body" scheme instead of header!
        request = consumer.create_signed_request(
            :post,
            path,
            nil,
            { scheme: 'body', timestamp: options['oauth_timestamp'], nonce: options['oauth_nonce'] },
            options
        )

        if uri.query_values
            # Remove them from the body.
            cleaned_query = Rack::Utils.parse_nested_query(request.body)
            uri.query_values.each do |_k, _v|
                # cleaned_query.delete k
                # cleaned_query.delete "custom_#{k}"
            end
            puts request.body = cleaned_query.to_query
        end
        request
    end
end
