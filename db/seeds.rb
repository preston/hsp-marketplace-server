# frozen_string_literal: true

# This is a general-purpose IDP for development purposes only.
# Please relpace this with your own, and NEVER use it for production!
idp = IdentityProvider.create_with(
  name: 'Logica Health',
  client_id: 'marketplace-server-development',
  client_secret: '233cec68-c4db-4948-9357-5b58b4004d4b',
  scopes: 'openid,email,profile,roles'
).find_or_create_by(issuer: 'https://id.logicahealth.org/auth/realms/master')
idp.reconfigure
idp.save!

mit = License.find_or_create_by!(name: 'MIT', url: 'https://opensource.org/licenses/MIT')
apache20 = License.find_or_create_by!(name: 'Apache 2.0', url: 'https://opensource.org/licenses/Apache-2.0')
bsd2 = License.find_or_create_by!(name: 'BSD 2-Clause', url: 'https://opensource.org/licenses/BSD-2-Clause')
bsd3 = License.find_or_create_by!(name: 'BSD 3-Clause', url: 'https://opensource.org/licenses/BSD-3-Clause')

administrator = User.find_or_create_by!(name: 'Administrator')

now = Time.now

headshot = File.new(File.join(Rails.root, 'public', 'headshot.jpg'))
hspc = File.new(File.join(Rails.root, 'public', 'hspc.png'))
asu = File.new(File.join(Rails.root, 'public', 'asu.jpg'))
mitre = File.new(File.join(Rails.root, 'public', 'mitre.png'))
placeholder = File.new(File.join(Rails.root, 'public', 'placeholder_logo.png'))

davinci = [
  { name: 'Patient Data Exchange Formulary Client',
    description: 'Da Vinci Plan Coverage and Medical Formulary Client Reference Implementation. The client reference implementation can installed and run locally on your machine.',
    license: apache20,
    user: administrator,
    uri: 'hspc/davinci-pdex-formulary-client',
    support_url: 'https://github.com/HL7-DaVinci/pdex-formulary-client',
    logo: mitre,
    published_at: now,
    visible_at: now },
  { name: 'Coverage Requirements Discovery (CRD) Server',
    description: 'The Coverage Requirements Discovery (CRD) Reference Implementation (RI) is a software project that conforms to the Implementation Guide developed by the Da Vinci Project within the HL7 Standards Organization. The CRD RI project is software that can simulate all of the systems involved in a CRD exchange. The main component in this project is the server, which acts as a healthcare payer information system. This system handles healthcare provider requests to understand what documentation is necessary prior to prescribing a particular treatment. Users are able to formulate a request for durable medical equipment coverage requirements, such as “what are the documentation requirements for prescribing home oxygen therapy (HCPCS E0424) to a 65 year old male living in MA?”. This type of question is not asked in plain English through a user interface, but submitted through CDS Hooks. The CRD RI consults a small, example database and provides a response, such as a PDF with the requirements back to the requesting system. This software lets EHR vendors and payer organizations examine how the proposed standard will work and test their own implementations of the standard.',
    license: apache20,
    user: administrator,
    uri: 'hspc/davinci-crd',
    support_url: 'https://github.com/HL7-DaVinci/CRD',
    logo: mitre,
    published_at: now,
    visible_at: now },
  { name: 'Documentation Templates and Rules (DTR) - SMART on FHIR Application',
    description: 'This subproject contains a SMART on FHIR app, which provides a standardized way to interact with FHIR servers. This Reference Impementation (RI) supports the Documents Templates and Rules (DTR) IG which specifies how payer rules can be executed in a provider context to ensure that documentation requirements are met. This RI and IG are companions to the Coverage Requirements Discovery (CRD) IG and Coverage Requirements Discovery (CRD) RI.',
    license: apache20,
    user: administrator,
    uri: 'hspc/davinci-dtr',
    support_url: 'https://github.com/HL7-DaVinci/dtr',
    logo: mitre,
    published_at: now,
    visible_at: now }
]
davinci.each do |n|
  s = Service.create!(n)
  s.save!
  Screenshot.create!(service: s, caption: 'Example screenshot 1', image: headshot)
  Screenshot.create!(service: s, caption: 'Example screenshot 2', image: headshot)
  Build.create!(
    service: s,
    service_version: 'latest',
    version: '0.0.0',
    container_repository: n[:uri],
    container_tag: 'latest',
    published_at: now,
    release_notes: 'Current build.',
    permissions: {}
  )
end


marketplace_server = Service.create!(
    name: 'Marketplace Server',
    description: 'The Health Service Platform Marketplace Server is a REST JSON API reference implementation for publication, discovery and management of published service container images. It is assumed to be a relying party to an externally preconfigured OpenID Connect Identity Provider SSO system according to the OAuth 2 specification. The simple API does not contain a UI other than for account management. A post-authentication dashboard URL must instead be injected at runtime. The underlying internal domain model is represented as a normalized relational (PostgeSQL) schema. The Marketplace Server auto-forward-migrates its own schema and includes all the tools you need to establish default data for your deployment.',
    license: apache20,
    user: administrator,
    logo: asu,
    uri: 'https://github.com/preston/hsp-marketplace-server',
    support_url: 'https://github.com/preston/hsp-marketplace-server',
    published_at: now,
    visible_at: now
  )


marketplace_ui = Service.create!(
    name: 'Marketplace UI',
    description: 'The Marketplace UI is web-based frontend for Marketplace Server, and requires an instance of the server to be launched.',
    license: apache20,
    user: administrator,
    logo: asu,
    uri: 'https://github.com/preston/hsp-marketplace-ui',
    support_url: 'https://github.com/preston/hsp-marketplace-ui',
    published_at: now,
    visible_at: now
  )

knartwork = Service.create!(
  name: 'Knartwork',
  description: 'KNARTwork is a multi-purpose web application for authoring, viewing, and transforming knowledge artifacts across popular specifications, with a strong slant towards healthcare-specific formats. By default, this application provides a purely standalone experience that does not use any standard-specific APIs (such as FHIR) or databases (such as RDBMS or NoSQL) systems, and may be used as-is by end users wanting to manage source documents as an out-of-band process using git/subversion, Dropbox, email etc.',
  license: apache20,
  user: administrator,
  logo: asu,
  uri: 'https://marketplace.hspconsortium.org/services/knartwork',
  support_url: 'https://github.com/cqframework/knartwork',
  published_at: now,
  visible_at: now
)

Screenshot.create!(service: knartwork, caption: 'Create new and update HL7 knowledge documents.', image: headshot)
Screenshot.create!(service: knartwork, caption: 'Manage metadata.', image: headshot)
Screenshot.create!(service: knartwork, caption: 'Create complex flows mapped to stardard terminologies.', image: headshot)

knartwork_build = Build.create!(
  service: knartwork,
  service_version: 'head',
  version: '0.5.1',
  container_repository: 'p3000/knartwork',
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
  logo: placeholder,
  uri: 'https://marketplace.hspconsortium.org/services/cql-translation-service',
  support_url: 'https://github.com/mitre/cql-translation-service',
  published_at: now,
  visible_at: now
)

Screenshot.create!(service: cql_translation_service, caption: 'An API for CQL-to-ELM conversion.', image: headshot)

cql_translation_service_build = Build.create!(
  service: cql_translation_service,
  service_version: 'head',
  version: '1.0.2',
  container_repository: 'p3000/cql-translation-service/',
  container_tag: 'v1.0.2',
  published_at: now,
  release_notes: 'Built from master HEAD December 2016. See the project source for API usage information.',
  permissions: {}
)

administrator_role = Role.create!(name: 'Administrator',
                                  description: 'Masters of the known universe, granted completed access to the system.',
                                  default: false,
                                  permissions: Role.merge_other_permissions_into_template(
                                    { 'everything' => { 'manage' => true } }, Role.permissions_template
                                  ))
standard_role = Role.create!(name: 'Standard User',
                             description: 'No-frills role assigned to all new users.',
                             default: true,
                             permissions: Role.merge_other_permissions_into_template({
                                                                                       'services' => { 'read' => true }
                                                                                     }, Role.permissions_template))

Appointment.create!(entity: administrator, role: administrator_role)

users = []
(0..42).each do |_n|
  users << u = User.create!(
    salutation: Faker::Name.prefix,
    name: Faker::Name.name,
    first_name: Faker::Name.first_name,
    middle_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name
  )
end
