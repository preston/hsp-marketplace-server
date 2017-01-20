jwt = request.headers['Authorization']
if jwt
    if jwt = JsonWebToken.decode_authorization(jwt)
        if jwt = JsonWebToken.find(jwt['id'])
            # json.identity do
            # 	id: jwt.identity.id,
            # 	user: {
            # 		id: jwt.identity.user.id,
            # 		name: jwt.identity.user.name,
            # 		url: user_url(jwt.identity.user),
            # 		path: user_path(jwt.identity.user)
            # 	}
            # end
            json.jwt do
                json.id jwt.id
                json.encoded jwt.encode
            end
        end
    end
end
json.message 'This application server and underlying database connection appear to be healthy.'
json.service do
    json.datetime Time.now
end
json.database do
    json.datetime Time.parse(ActiveRecord::Base.connection.select_value('SELECT CURRENT_TIME'))
end
# json.session_dump session.inspect
if @current_identity
    json.identity do
        json.id @current_identity.id
        json.user_id @current_user.id
        json.user do
            json.partial! 'users/user', user: @current_user
        end
        json.provider do
            json.id @current_identity.identity_provider.id
            json.name @current_identity.identity_provider.name
        end
    end
    json.permissions @current_user.permissions

end
