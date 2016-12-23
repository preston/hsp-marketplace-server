class WelcomeController < ApplicationController
    skip_before_action	:authenticate_identity!, only: [:landing, :status]
    skip_authorization_check

    def landing
        @skip_navigation = true
    end

    def dashboard; end

    def status
        json = {}
        jwt = request.headers['Authorization']
        if jwt
            if jwt = JsonWebToken.decode_authorization(jwt)
                if jwt = JsonWebToken.find(jwt['id'])
                    json.merge!(
                        identity: {
                            id: jwt.identity.id,
                            user: {
                                id: jwt.identity.user.id,
                                name: jwt.identity.user.name,
                                url: user_url(jwt.identity.user),
                                path: user_path(jwt.identity.user)
                            }
                        },
                        jwt: { id: jwt.id, encoded: jwt.encode }
                    )
                end
            end
        end
        json.merge!(
            message: 'This application server and underlying database connection appear to be healthy.',
            service: {
                datetime: Time.now
            },
            database: {
                datetime: Time.parse(ActiveRecord::Base.connection.select_value('SELECT CURRENT_TIME'))
            }
        )
        render json: json, status: :ok
    end
end
