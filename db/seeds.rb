# This is a general-purpose IDP for development purposes only.
# Please relpace this with your own, and NEVER use it for production!
google = IdentityProvider.create_with(
    name: 'Google',
    client_id: '418783041492-sfsdepjvultlju47mvtcrm2ug3gjumo0.apps.googleusercontent.com',
    client_secret: 'tlaAwAx-1MH3YAm1fkFbFCvY',
    scopes: 'openid email profile'
).find_or_create_by(issuer: 'https://accounts.google.com')
google.reconfigure
google.save!

mit = License.create!(name: 'MIT', url: 'https://opensource.org/licenses/MIT')
apache20 = License.create!(name: 'Apache 2.0', url: 'https://opensource.org/licenses/Apache-2.0')
bsd2 = License.create!(name: 'BSD 2-Clause', url: 'https://opensource.org/licenses/BSD-2-Clause')
bsd3 = License.create!(name: 'BSD 3-Clause', url: 'https://opensource.org/licenses/BSD-3-Clause')

administrator = User.create!(name: 'Administrator')
# Client.create!(
#     name: "Preston's Client",
#     launch_url: 'https://marketplace.healthcreek.org/index.html',
#     icon_url: 'http://marketplace.healthcreek.org/app/images/textures/tileable_wood_texture.png',
#     available: true
# )

now = Time.now

knartwork = Service.create!(
    name: 'Knartwork',
    description: 'KNARTwork is a multi-purpose web application for authoring, viewing, and transforming knowledge artifacts across popular specifications, with a strong slant towards healthcare-specific formats. By default, this application provides a purely standalone experience that does not use any standard-specific APIs (such as FHIR) or databases (such as RDBMS or NoSQL) systems, and may be used as-is by end users wanting to manage source documents as an out-of-band process using git/subversion, Dropbox, email etc.',
    license: apache20,
    user: administrator,
    uri: 'https://marketplace.hspconsortium.org/services/knartwork',
    support_url: 'https://github.com/cqframework/knartwork',
    approved_at: now,
    visible_at: now
)

knartwork_build = Build.create!(
    service: knartwork,
    service_version: 'head',
    version: '0.5.1',
    container_respository_url: 'https://hub.docker.com/r/p3000/knartwork/',
    container_tag: 'v0.5.1',
    published_at: now,
    release_notes: 'From service source of the same release tag.',
    permissions: {}
)

cql_translation_service = Service.create!(
    name: 'CQL Translation Service',
    description: 'A microservice wrapper for the CQL to ELM conversion library.',
    license: apache20,
    user: administrator,
    uri: 'https://marketplace.hspconsortium.org/services/cql-translation-service',
    support_url: 'https://github.com/mitre/cql-translation-service',
    approved_at: now,
    visible_at: now
)

cql_translation_service_build = Build.create!(
    service: cql_translation_service,
    service_version: 'head',
    version: '1.0.2',
    container_respository_url: 'https://hub.docker.com/r/p3000/cql-translation-service/',
    container_tag: 'v1.0.2',
    published_at: now,
    release_notes: 'Built from master HEAD December 2016. See the project source for API usage information.',
    permissions: {}
)

administrator_role = Role.create!(
    name: 'Administrator',
    code: 'administrator',
    default: false
)
Appointment.create!(entity: administrator, role: administrator_role)

default_role = Role.create!(
    name: 'Default',
    code: 'default',
    default: true
)

users = []
(0..100).each do |_n|
    users << u = User.create!(
        salutation: Faker::Name.prefix,
        name: Faker::Name.name,
        first_name: Faker::Name.first_name,
        middle_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name
    )
    Role.where(default: true).all.each do |r|
        Appointment.create!(entity: u, role: r)
    end
end
