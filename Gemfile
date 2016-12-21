source 'https://rubygems.org'
ruby '2.3.3'

gem 'rails', '5.0.0.1'	# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'sass-rails'	# Use SCSS for stylesheets
gem 'uglifier'			# Use Uglifier as compressor for JavaScript assets

gem 'jbuilder'			# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'sdoc', group: :doc # bundle exec rake doc:rails generates the API under doc/api.

gem 'will_paginate' # Better query pagination support.

gem 'therubyracer'	# Required at deploy time for asset precompilation.

gem 'openid_connect'

gem 'slim' # Better HTML templating.

gem 'jwt'	# All API calls require JWT-signed requests!
gem 'cancancan'	# Declarative authorization DSL.

gem 'puma' # Better web server
gem 'pg' # Only PostgreSQL is supported!
gem 'pg_search' # Full-text search. RAD!!!

gem 'httparty'  # Simple REST client.
gem 'faker'	# For generating synthetic data.

# PURELY CLIENT-SIDE STUFF
gem 'gravatar_image_tag'
# General jQuery.
gem 'jquery-rails'
gem 'jquery-ui-rails'
# gem 'chosen-rails'
gem 'bootstrap-sass'
gem 'autoprefixer-rails'
gem 'font-awesome-rails' # Better icons for Bootstrap

group :development, :test do
    gem 'byebug' # Call 'byebug' anywhere in the code to stop execution and get a debugger console
end

group :development do
    # gem 'web-console', '~> 2.0'     # Access an IRB console on exception pages or by using <%= console %> in views
    gem 'spring' # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
    gem 'guard'
    gem 'railroady'
    gem 'rubocop' # For editor reformatting support
end
