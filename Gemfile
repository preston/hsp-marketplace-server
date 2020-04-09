source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

gem 'rails'	# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'bootsnap'

gem 'jbuilder'			# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'sdoc', group: :doc # bundle exec rake doc:rails generates the API under doc/api.

gem 'will_paginate' # Better query pagination support.

gem 'openid_connect'
gem 'devise'	# Assists with OAuth2 stuff.

gem 'slim' # Better HTML templating.

gem 'jwt'	# All API calls require JWT-signed requests!
gem 'cancancan'	# Declarative authorization DSL.

# gem 'puma' # Better web server
gem 'pg' # Only PostgreSQL is supported!
gem 'pg_search' # Full-text search. RAD!!!
gem 'redis' # WebSockets!
gem 'rack-cors'	# Allowing cross-origin clients.. which is all of them.

gem 'httparty'  # Simple REST client.
gem 'faker'	# For generating synthetic data.

gem 'rexml'

group :development, :test do
    gem 'guard'
    gem 'guard-minitest'
end

group :development do
    # gem 'web-console', '~> 2.0'     # Access an IRB console on exception pages or by using <%= console %> in views
    gem 'spring' # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
    gem 'railroady'
    gem 'rubocop-rails' # For editor reformatting support
	gem 'byebug' # Call 'byebug' anywhere in the code to stop execution and get a debugger console
	gem 'web-console'
	gem 'binding_of_caller'
end

