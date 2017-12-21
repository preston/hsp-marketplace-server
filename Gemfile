source 'https://rubygems.org'
ruby '2.4.2'

gem 'rails', '5.1.4'	# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'

gem 'jbuilder'			# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'sdoc', group: :doc # bundle exec rake doc:rails generates the API under doc/api.

gem 'will_paginate' # Better query pagination support.

gem 'openid_connect'
gem 'devise'	# Assists with OAuth2 stuff.

gem 'slim' # Better HTML templating.

gem 'jwt'	# All API calls require JWT-signed requests!
gem 'cancancan'	# Declarative authorization DSL.

gem 'puma' # Better web server
gem 'pg' # Only PostgreSQL is supported!
gem 'pg_search' # Full-text search. RAD!!!
gem 'redis' # WebSockets!
gem 'rack-cors'	# Allowing cross-origin clients.. which is all of them.

gem 'httparty'  # Simple REST client.
gem 'faker'	# For generating synthetic data.
gem 'paperclip'	# Dealing with images.
gem 'paperclip_database', git: 'https://github.com/pwnall/paperclip_database.git', branch: 'rails5' # For database storage. Using a fork for Rails 5 support, unfortunately. :(

# group :development, :test do
# end

group :development do
    # gem 'web-console', '~> 2.0'     # Access an IRB console on exception pages or by using <%= console %> in views
    gem 'spring' # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
    gem 'guard'
    gem 'railroady'
    gem 'rubocop' # For editor reformatting support
	gem 'byebug' # Call 'byebug' anywhere in the code to stop execution and get a debugger console
	gem 'web-console'
	gem 'binding_of_caller'
end
