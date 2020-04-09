# Health Services Platform - Marketplace Server

The Health Services Platform Marketplace Server is a REST JSON API reference implementation for publication, discovery and management of published product container images. It is assumed to be a relying party to an externally preconfigured OpenID Connect Identity Provider SSO system according to the OAuth 2 specification. The simple API does not contain a UI other than for account management. A post-authentication dashboard URL must instead be injected at runtime. The underlying internal domain model is represented as a normalized relational (PostgeSQL) schema. The Marketplace Server auto-forward-migrates its own schema and includes all the tools you need to establish default data for your deployment. For details, see:

https://healthservices.atlassian.net/wiki/display/PE/Platform+Engineering

# Conceptual Overview

The system allows for initial web-based login via a configurable set OpenID Connect providers: part of the OAuth2 family of protocols. After, both a browser-based sessions is established, as well as a JWT that may be used to access the API for a time-limited period. As this is a model-driven system, the documentation is generated based on the model. For what the API actually does, see:

* [High-Level List of REST Routes](https://github.com/preston/marketplace-server/blob/master/doc/routes.txt) - This is a generated dump.
* [Interactive API Tutorial](https://github.com/preston/marketplace-server/blob/master/doc/marketplace.paw). *Note*: You'll need [Paw](https://luckymarmot.com/paw) for OS X to open this, and need to replace the JWT and server instance configuration with your own details to run it.
* [Schema Diagram](https://github.com/preston/marketplace-server/blob/master/doc/models_complete.svg) - This is a normalized .svg showing the physical database model, with additional OR/M-level annotations. It's useful in understanding how resources relate behind the API.
* [Database DSL](https://github.com/preston/marketplace-server/blob/master/db/schema.rb) - Generated database schema in ActiveRecord format.

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

Create a "marketplace-server" Postgres user using the dev/test credentials in config/database.yml, and assigned them full rights to manage schemas. As with most Ruby projects, use [RVM](https://rvm.io) to manage your local Ruby versions. [Install RVM](https://rvm.io) and:

	rvm install 2.4.1
	rvm use 2.4.1

Then,

	bundle install # to install all server-side library dependencies.

The HSP Marketplace Server application is designed in [12factor](http://12factor.net) style. Thus, the following environment variables are required to be set to support cookie-based CDN authorization grants. Set these in your ~/.bash_profile (or similar) and reload your terminal.

 * export MARKETPLACE\_PASSWORD\_SALT="some\_unique\_string" # Used for database password salting.
 * export MARKETPLACE\_SECRET\_KEY\_BASE="some\_unique\_string" # Used for cryptographic signing of user sessions.
 * export MARKETPLACE\_DATABASE\_URL="postgres://marketplace:password@db.example.com:5432/marketplace_production
" # Only used in "production" mode!
 * export MARKETPLACE\_DATABASE\_URL\_TEST="postgres://marketplace:password@db.example.com:5432/marketplace\_test
" # Only used in "test" mode!
* export MARKETPLACE\_REDIS\_URL="redis://localhost:6379"


The following additional environment variables are optional, but potentially useful in a production context. Note that the database connection pool is adjusted automatically based on these values. If in doubt, do NOT set these.

 * export MARKETPLACE\_MIN\_THREADS=5 # To override the minimum number of threads per process.
 * export MARKETPLACE\_MAX\_THREADS=5 # To override the maximum number of threads per process.

Now,

	rake db:create # to create empty marketplace_development and marketplace_test databases in Postgres
	rake db:migrate # to apply all database migrations, in order, transactionally
	rake db:seed # loads a simple set of starter data
	rake test # to run all regression tests and generate a code coverage report. everything should pass!

You're now ready to run the application.

	rails s # to run the server in development mode in the foreground.

To automatically re-run regression tests on detected code changes, open another terminal window and run

	guard # hit <enter> to manually re-run all tests to run if a change isn't detected

# Optional Data

We have bundled in support to import/export data from several notable sources. Please feel free to  

## Import HL7 knowledge artifacts
The `rake marketplace:import:knart:manifest` task takes a directory of manifested KNARTs and upserts them as distinct products.

	# Required: Directory where the manifest.json lives.
	export MARKETPLACE_IMPORT_ROOT=/Users/preston/Developer/git/vha-kbs-knarts/

	# Required: Existing User.name that will be set as the owner of all upserted Products.
	export MARKETPLACE_IMPORT_OWNER_NAME=Administrator

	# Optional: Existing License.name that will be set as an available License of all upserted Products.
	export MARKETPLACE_IMPORT_LICENSE_NAME="Apache 2.0"
	
	# Optional: Existing License.name that will be set as an available License of the upserted meta-Product. If set, you might want to unset MARKETPLACE_IMPORT_LICENSE_NAME if you only want to allow licensing of the meta-Product.
	export MARKETPLACE_IMPORT_META_LICENSE_NAME="Apache 2.0"

	# Optional: Support URL for products.
	export MARKETPLACE_KNART_SUPPORT_URL="https://github.com/osehra/vha-kbs-knarts"


## Import Products from FHIR StructureDefinition XML Files
The `rake marketplace:import:fhir:structuredefinition` task takes a directory of valid, well-formed XML files and imports them as distinct products. This is technically an _upsert_ operation,  as existing Products (of the same name as the FHIR StructureDefinition) will be updated instead of overwritten when found. The following will be read:

	# Required: Directory where the XML files are. Non-recursive.
	export MARKETPLACE_IMPORT_ROOT=/Users/preston/Developer/git/HSPCFHIRtest/resources/structuredefinition

	# Required: Existing User.name that will be set as the owner of all upserted Products.
	export MARKETPLACE_IMPORT_OWNER_NAME=Administrator

	# Optional: Existing License.name that will be set as an available License of all upserted Products.
	export MARKETPLACE_IMPORT_LICENSE_NAME="Creative Commons Attribution 4.0 International"

	# Optional: Skip files with these names. Useful when you have other XML files in the same directory.
	export MARKETPLACE_IMPORT_IGNORE="practitioner.xml,organization.xml"


## Import the HL7 LOINC 2K Clinical Models
`rake marketplace:import:fhir:loinc2k` is the same as `rake marketplace:import:fhir:structuredefinition`, but also upserts a meta-Products including every found StructureDefinition for one-click licensing of the entire collection. The following are additional read:

	# Optional: Existing License.name that will be set as an available License of the upserted meta-Products. If set, you might want to unset MARKETPLACE_IMPORT_LICENSE_NAME if you only want to allow licensing of the meta-Product.
	export MARKETPLACE_IMPORT_META_LICENSE_NAME="LOINC and RELMA"


# Deployment

Deployment is done exclusively with Docker, though "raw" deployment using Passenger and all another common methods, including Heroku, are supported as well.

## Building a Container

To build your current version:

	docker build -t p3000/marketplace-server:latest .

## Running a Container

You need a recent PostgreSQL database set up with an empty schema ready for the Marketplace to use. The schema will be automatically forward-migrated to the most current state every time the container starts.

When running the container, **all environment variables defined in the above section must be set using `-e FOO="bar"` options** to docker. The foreground form of the command is:

	docker run -it --rm -p 3000:3000 --name marketplace-server \
		-e "MARKETPLACE_UI_URL=http://localhost:9000" \
		-e "MARKETPLACE_TITLE=My Marketplace" \
		-e "MARKETPLACE_SECRET_KEY_BASE=development_only" \
		-e "MARKETPLACE_DATABASE_URL=postgresql://marketplace:password@192.168.1.115:5432/marketplace_development" \
		p3000/marketplace-server:latest

...or to run in the background:

	docker run -d -p 3000:3000 --name marketplace-server \
		-e "MARKETPLACE_UI_URL=http://localhost:9000" \
		-e "MARKETPLACE_TITLE=My Marketplace" \
		-e "MARKETPLACE_SECRET_KEY_BASE=development_only" \
		-e "MARKETPLACE_DATABASE_URL=postgresql://marketplace:password@192.168.1.103:5432/marketplace_development" \
		p3000/marketplace-server:latest

Once your server appears to be running, check your Postgres database to make sure tables have been created. First, run the including data seeding script: (You may keep any existing Makretplace containers running.)

	docker run -it --rm -p 3000:3000 --name marketplace-server \
		-e "MARKETPLACE_UI_URL=http://localhost:9000" \
		-e "MARKETPLACE_TITLE=My Marketplace" \
		-e "MARKETPLACE_SECRET_KEY_BASE=development_only" \
		-e "MARKETPLACE_DATABASE_URL=postgresql://marketplace:password@192.168.1.115:5432/marketplace_development" \
		p3000/marketplace-server:latest \
		rake db:seed

This should be fast, and the script will exit once completed. Finally, you'll want to add a default data set and establish yourself as the initial administrator. Since the Marketplace _requires_ an OpenID Connect identity provider (IDP) and does not authenticate on its own, the initial IDP setup takes a few additional steps. Once the first IDP is established, however, all future IDPs may be managed by the Marketplace UI or another client.

The seed data includes a default configuration for Google as an example. To use it, go to the [Google Developers Console](https://console.developers.google.com) -> Credentials and create an "OAutuh Client ID" for a "web application". Note the client ID and client secret, which are specific to _your_ installation. Now, start an interactive container into Marketplace Console mode to update the IDP configuration.

	docker run -it --rm -p 3000:3000 --name marketplace-server \
		-e "MARKETPLACE_UI_URL=http://localhost:9000" \
		-e "MARKETPLACE_TITLE=My Marketplace" \
		-e "MARKETPLACE_SECRET_KEY_BASE=development_only" \
		-e "MARKETPLACE_DATABASE_URL=postgresql://marketplace:password@192.168.1.115:5432/marketplace_development" \
		p3000/marketplace-server:latest \
		rails console

	idp = IdentityProvider.where(name: 'Google').first
	idp.client_id = 'your_client_id'
	idp.client_secret = 'your_client_secret'
	idp.save!

Load a Marketplace UI in your browser and test your configuration. You should be able to log in using your existing Google account, which will trigger the Marketplace to create a local account for you as well. Finally, make yourself a full administrator at the previous contaier console by assigning your account to the adminstrator role.

	me = idp.identities.first.user
	administrator_role = Role.where(name: 'Administrator').first
	Appointment.create(entity: me, role: administrator_role)

You're done! You may now use the Marketplace UI for all further admistratration. You should probably back up your database, too. ;)

## Regression Testing a Container

The container includes a regression test suite to ensure proper operation. Running in test mode is slightly different, as to not inadvertently affect your production database(s). The application server process must also be told to run in 'test' mode.

	docker run -it -m="512MB" \
		-e "RAILS_ENV=test" \
		-e "MARKETPLACE_DATABASE_URL_TEST=postgresql://hsp_marketplace:password@192.168.1.103:5432/marketplace_test" \
		... \
		p3000/marketplace-server:latest \
		rake test


# License

[Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0)
