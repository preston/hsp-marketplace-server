# HSP Marketplace Server

The Health Service Platform Marketplace Server is a REST JSON API reference implementation for publication, discovery and management of published service container images. It is assumed to be a relying party to an externally preconfigured OpenID Connect Identity Provider SSO system according to the OAuth 2 specification. The simple API does not contain a UI other than for account management. A post-authentication dashboard URL must instead be injected at runtime. The underlying internal domain model is represented as a normalized relational (PostgeSQL) schema. For details, see:

https://healthservices.atlassian.net/wiki/display/PE/Platform+Engineering

# Conceptual Overview

The system allows for initial web-based login via a configurable set OpenID Connect providers: part of the OAuth2 family of protocols. After, both a browser-based sessions is established, as well as a JWT that may be used to access the API for a time-limited period. As this is a model-driven system, the documentation is generated based on the model. For what the API actually does, see:

* [High-Level List of REST Routes](https://github.com/preston/hsp-marketplace-server/blob/master/doc/routes.txt) - This is a generated dump.
* [Interactive API Tutorial](https://github.com/preston/hsp-marketplace-server/blob/master/doc/marketplace.paw). *Note*: You'll need [Paw](https://luckymarmot.com/paw) for OS X to open this, and need to replace the JWT and server instance configuration with your own details to run it.
* [Schema Diagram](https://github.com/preston/hsp-marketplace-server/blob/master/doc/models_complete.svg) - This is a normalized .svg showing the physical database model, with additional OR/M-level annotations. It's useful in understanding how resources relate behind the API.
* [Database DSL](https://github.com/preston/hsp-marketplace-server/blob/master/db/schema.rb) - Generated database schema in ActiveRecord format.

# The API

## Pre-existing Security Resources

These endpoints would be pre-populated with "real" user data in an implementation prior to any actual use case. Most REST verbs are supported, used in the standard path'ing practice of "/<plural_noun>", "/<plural_noun>/:id", and utilization of sub-resources to represent model compositions and aggregations, when appropriate.

	/users # Generic type for all known users.
	/users/:id/identities # Actual authentication-related details specific to the IAM system.
	/users/:id/roles # Roles granted to the User.
	/groups	# An aggregation of Users.
	/groups/:id/members # Establishes a given User's membership in a Group.
	/groups/:id/roles # Roles granted to the Group; transitively to all Members.
	/roles # Defines a granular set of permissions.

# Developer Quick Start (OSX with Homebrew)

If you don't already have Postgres running locally:

    brew install postgresql

Create a "hsp-marketplace-server" Postgres user using the dev/test credentials in config/database.yml, and assigned them full rights to manage schemas. As with most Ruby projects, use [RVM](https://rvm.io) to manage your local Ruby versions. [Install RVM](https://rvm.io) and:

	rvm install 2.3.3
	rvm use 2.3.3

Then,

	bundle install # to install all server-side library dependencies.

The HSP Marketplace Server application is designed in [12factor](http://12factor.net) style. Thus, the following environment variables are required to be set to support cookie-based CDN authorization grants. Set these in your ~/.bash_profile (or similar) and reload your terminal.

 * export MARKETPLACE\_PASSWORD\_SALT="some\_unique\_string" # Used for database password salting.
 * export MARKETPLACE\_SECRET\_KEY\_BASE="some\_unique\_string" # Used for cryptographic signing of user sessions.
 * export MARKETPLACE\_DATABASE\_URL="postgres://marketplace:password@db.example.com:5432/marketplace_production
" # Only used in "production" mode!
 * export MARKETPLACE\_DATABASE\_URL\_TEST="postgres://marketplace:password@db.example.com:5432/marketplace\_test
" # Only used in "test" mode!


The following additional environment variables are optional, but potentially useful in a production context. Note that the database connection pool is adjusted automatically based on these values. If in doubt, do NOT set these.

 * export MARKETPLACE\_SERVER\_PROCESSES=8 # To override the number of pre-forked workers.
 * export MARKETPLACE\_SERVER\_THREAD=8 # To override the number of threads per process.

Now,

	rake db:create # to create empty marketplace_development and marketplace_test databases in Postgres
	rake db:migrate # to apply all database migrations, in order, transactionally
	rake db:seed # loads a simple set of starter data
	rake test # to run all regression tests and generate a code coverage report. everything should pass!

You're now ready to run the application.

	rails s # to run the server in development mode in the foreground.

To automatically re-run regression tests on detected code changes, open another terminal window and run

	guard # hit <enter> to manually re-run all tests to run if a change isn't detected

# Deployment

Deployment is done exclusively with Docker, though "raw" deployment using Passenger and all another common methods, including Heroku, are supported as well.

## Building a Container

To build your current version:

	docker build -t p3000/hsp-marketplace-server:latest .

## Running a Container

When running the container, **all environment variables defined in the above section must be set using `-e FOO="bar"` options** to docker. The foreground form of the command is:

	docker run -it --rm -p 3000:3000 --name hsp-marketplace-server \
		-e "MARKETPLACE_UI_URL=http://localhost:9000" \
		-e "MARKETPLACE_TITLE=My Marketplace" \
		-e "MARKETPLACE_PASSWORD_SALT=development_only" \
		-e "MARKETPLACE_SECRET_KEY_BASE=development_only" \
		-e "MARKETPLACE_DATABASE_URL=postgresql://marketplace:password@192.168.1.115:5432/marketplace_development" \
		p3000/hsp-marketplace-server:latest

...or to run in the background:

	docker run -d -p 3000:3000 --name hsp-marketplace-server \
		-e "MARKETPLACE_UI_URL=http://localhost:9000" \
		-e "MARKETPLACE_TITLE=My Marketplace" \
		-e "MARKETPLACE_PASSWORD_SALT=development_only" \
		-e "MARKETPLACE_SECRET_KEY_BASE=development_only" \
		-e "MARKETPLACE_DATABASE_URL=postgresql://marketplace:password@192.168.1.103:5432/marketplace_development" \
		p3000/hsp-marketplace-server:latest

## Regression Testing a Container

The container includes a regression test suite to ensure proper operation. Running in test mode is slightly different, as to not inadvertently affect your production database(s). The application server process must also be told to run in 'test' mode.

	docker run -it -m="512MB" \
		-e "RAILS_ENV=test" \
		-e "MARKETPLACE_DATABASE_URL_TEST=postgresql://hsp_marketplace:password@192.168.1.103:5432/marketplace_test" \
		... \
		p3000/hsp-marketplace-server:latest \
		rake test


# License

[Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0)
