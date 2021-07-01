source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.1'

gem 'rails', '>= 6.1.4'	# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'bootsnap', require: false # Reduces boot times through caching; required in config/boot.rb

gem 'jbuilder'			# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder

gem 'will_paginate' # Better query pagination support.

gem 'openid_connect'
gem 'devise'	# Assists with OAuth2 stuff.

gem 'slim' # Better HTML templating.

gem 'jwt'	# All API calls require JWT-signed requests!
gem 'cancancan'	# Declarative authorization DSL.

gem 'puma' # Better web server
gem 'pg' # Only PostgreSQL is supported!
gem 'pg_search' # Full-text search. RAD!!!
gem 'redis' # WebSockets! Used for Action Cable.
gem 'rack-cors'	# Allowing cross-origin clients.. which is all of them.

gem 'httparty'  # Simple REST client.
gem 'faker'	# For generating synthetic data.

gem 'rexml' # XML handling. Must be bundled starting with Ruby 3.0.0
gem 'thread_safe' # Internal global caches of stuff

gem 'sdoc', group: :doc # bundle exec rake doc:rails generates the API under doc/api.

group :development, :test do
    gem 'byebug', platforms: [:mri, :mingw, :x64_mingw] # Call 'byebug' anywhere in the code to stop execution and get a debugger console
    gem 'guard'
    gem 'guard-minitest'

    gem 'rails-controller-testing'
    # Adds support for Capybara system testing and selenium driver
    # gem 'capybara', '>= 3.26'
    # gem 'selenium-webdriver'
    # Easy installation and use of web drivers to run system tests with browsers
    # gem 'webdrivers'
end

group :development do
    # gem 'web-console', '~> 2.0'     # Access an IRB console on exception pages or by using <%= console %> in views
    gem 'spring' # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
    gem 'railroady'
    gem 'rubocop-rails' # For editor reformatting support
    gem 'web-console'
    gem 'rack-mini-profiler', '~> 2.0'
    gem 'listen', '~> 3.3'
    # gem 'binding_of_caller'
    gem 'rubocop'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]