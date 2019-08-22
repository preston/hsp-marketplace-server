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

mit = License.find_or_create_by!(name: 'MIT', url: 'https://opensource.org/licenses/MIT', expiry: License::EXPIRY_INDEFINITE)
apache20 = License.find_or_create_by!(name: 'Apache 2.0', url: 'https://opensource.org/licenses/Apache-2.0', expiry: License::EXPIRY_INDEFINITE)
bsd2 = License.find_or_create_by!(name: 'BSD 2-Clause', url: 'https://opensource.org/licenses/BSD-2-Clause', expiry: License::EXPIRY_INDEFINITE)
bsd3 = License.find_or_create_by!(name: 'BSD 3-Clause', url: 'https://opensource.org/licenses/BSD-3-Clause', expiry: License::EXPIRY_INDEFINITE)
cc0 = License.find_or_create_by!(name: 'Creative Commons Zero 1.0 Universal', url: 'https://creativecommons.org/publicdomain/zero/1.0/', expiry: License::EXPIRY_INDEFINITE)
ccby = License.find_or_create_by!(name: 'Creative Commons Attribution 4.0 International', url: 'https://creativecommons.org/licenses/by/4.0/', expiry: License::EXPIRY_INDEFINITE)
loinc = License.find_or_create_by!(name: 'LOINC and RELMA', url: 'https://loinc.org/license/', expiry: License::EXPIRY_INDEFINITE)

administrator = User.find_or_create_by!(name: 'Administrator')

now = Time.now

headshot = File.open(File.join(Rails.root, 'public', 'headshot.jpg'))
hspc = File.open(File.join(Rails.root, 'public', 'hspc.png'))
asu = File.open(File.join(Rails.root, 'public', 'asu.jpg'))
mitre = File.open(File.join(Rails.root, 'public', 'mitre.png'))
placeholder = File.open(File.join(Rails.root, 'public', 'placeholder_logo.png'))

davinci = [
  { name: 'Patient Data Exchange Formulary Client',
    description: 'Da Vinci Plan Coverage and Medical Formulary Client Reference Implementation. The client reference implementation can installed and run locally on your machine.',
    user: administrator,
    uri: 'hspc/davinci-pdex-formulary-client',
    support_url: 'https://github.com/HL7-DaVinci/pdex-formulary-client',
    mime_type: 'application/vnd.docker+smart',
    published_at: now,
    visible_at: now },
  { name: 'Coverage Requirements Discovery (CRD) Server',
    description: 'The Coverage Requirements Discovery (CRD) Reference Implementation (RI) is a software project that conforms to the Implementation Guide developed by the Da Vinci Project within the HL7 Standards Organization. The CRD RI project is software that can simulate all of the systems involved in a CRD exchange. The main component in this project is the server, which acts as a healthcare payer information system. This system handles healthcare provider requests to understand what documentation is necessary prior to prescribing a particular treatment. Users are able to formulate a request for durable medical equipment coverage requirements, such as “what are the documentation requirements for prescribing home oxygen therapy (HCPCS E0424) to a 65 year old male living in MA?”. This type of question is not asked in plain English through a user interface, but submitted through CDS Hooks. The CRD RI consults a small, example database and provides a response, such as a PDF with the requirements back to the requesting system. This software lets EHR vendors and payer organizations examine how the proposed standard will work and test their own implementations of the standard.',
    user: administrator,
    uri: 'hspc/davinci-crd',
    support_url: 'https://github.com/HL7-DaVinci/CRD',
    mime_type: 'application/vnd.docker+fhir',
    published_at: now,
    visible_at: now },
  { name: 'Documentation Templates and Rules (DTR) - SMART on FHIR Application',
    description: 'This subproject contains a SMART on FHIR app, which provides a standardized way to interact with FHIR servers. This Reference Impementation (RI) supports the Documents Templates and Rules (DTR) IG which specifies how payer rules can be executed in a provider context to ensure that documentation requirements are met. This RI and IG are companions to the Coverage Requirements Discovery (CRD) IG and Coverage Requirements Discovery (CRD) RI.',
    user: administrator,
    uri: 'hspc/davinci-dtr',
    support_url: 'https://github.com/HL7-DaVinci/dtr',
    mime_type: 'application/vnd.docker+smart',
    published_at: now,
    visible_at: now }
]
davinci.each do |n|
  s = Product.create!(n)
  mitre.rewind
  s.logo.attach(io: mitre, filename: File.basename(mitre.path))
  mitre.rewind
  s.save!
  ProductLicense.create!(product: s, license: apache20)
 
  screenshot = Screenshot.create!(product: s, caption: 'Example screenshot 1')
  screenshot.image.attach(io: placeholder, filename: File.basename(placeholder.path))
  placeholder.rewind
  screenshot.save!
 
  screenshot =  Screenshot.create!(product: s, caption: 'Example screenshot 2')
  screenshot.image.attach(io: placeholder, filename: File.basename(placeholder.path))
  placeholder.rewind
  screenshot.save!
  Build.create!(
    product: s,
    version: '0.0.0',
    container_repository: n[:uri],
    container_tag: 'latest',
    published_at: now,
    release_notes: 'Current build.',
    permissions: {}
  )
end


marketplace_server = Product.create!(
    name: 'Marketplace Server',
    description: 'The Health Product Platform Marketplace Server is a REST JSON API reference implementation for publication, discovery and management of published product container images. It is assumed to be a relying party to an externally preconfigured OpenID Connect Identity Provider SSO system according to the OAuth 2 specification. The simple API does not contain a UI other than for account management. A post-authentication dashboard URL must instead be injected at runtime. The underlying internal domain model is represented as a normalized relational (PostgeSQL) schema. The Marketplace Server auto-forward-migrates its own schema and includes all the tools you need to establish default data for your deployment.',
    user: administrator,
    uri: 'https://github.com/preston/hsp-marketplace-server',
    support_url: 'https://github.com/preston/hsp-marketplace-server',
    mime_type: 'application/vnd.docker',
    published_at: now,
    visible_at: now
  )
marketplace_server.logo.attach(io: asu, filename: File.basename(asu.path))
asu.rewind
marketplace_server.save!
ProductLicense.create!(product: marketplace_server, license: apache20)


marketplace_ui = Product.create!(
    name: 'Marketplace UI',
    description: 'The Marketplace UI is web-based frontend for Marketplace Server, and requires an instance of the server to be launched.',
    user: administrator,
    uri: 'https://github.com/preston/hsp-marketplace-ui',
    support_url: 'https://github.com/preston/hsp-marketplace-ui',
    mime_type: 'application/vnd.docker',
    published_at: now,
    visible_at: now
  )
marketplace_ui.logo.attach(io: asu, filename: File.basename(asu.path))
asu.rewind
marketplace_ui.save!
ProductLicense.create!(product: marketplace_ui, license: apache20)

# knartwork = Product.create!(
#   name: 'Knartwork2',
#   description: 'KNARTwork is a multi-purpose web application for authoring, viewing, and transforming knowledge artifacts across popular specifications, with a strong slant towards healthcare-specific formats. By default, this application provides a purely standalone experience that does not use any standard-specific APIs (such as FHIR) or databases (such as RDBMS or NoSQL) systems, and may be used as-is by end users wanting to manage source documents as an out-of-band process using git/subversion, Dropbox, email etc.',
#   user: administrator,
#   logo: placeholder,
#   uri: 'https://marketplace.hspconsortium.org/products/knartwork',
#   support_url: 'https://github.com/cqframework/knartwork',
#   published_at: now,
#   visible_at: now
# )
knartwork = Product.create!(
  name: 'Knartwork',
  description: 'KNARTwork is a multi-purpose web application for authoring, viewing, and transforming knowledge artifacts across popular specifications, with a strong slant towards healthcare-specific formats. By default, this application provides a purely standalone experience that does not use any standard-specific APIs (such as FHIR) or databases (such as RDBMS or NoSQL) systems, and may be used as-is by end users wanting to manage source documents as an out-of-band process using git/subversion, Dropbox, email etc.',
  user: administrator,
  uri: 'https://marketplace.hspconsortium.org/products/knartwork',
  support_url: 'https://github.com/cqframework/knartwork',
  mime_type: 'application/vnd.docker',
  published_at: now,
  visible_at: now
)
knartwork.logo.attach(io: asu, filename: File.basename(asu.path))
knartwork.logo.analyze
asu.rewind
knartwork.save!
ProductLicense.create!(product: knartwork, license: apache20)

screenshot = Screenshot.create!(product: knartwork, caption: 'Create new and update HL7 knowledge documents.')
screenshot.image.attach(io: placeholder, filename: File.basename(placeholder.path))
placeholder.rewind
screenshot.save!

screenshot = Screenshot.create!(product: knartwork, caption: 'Manage metadata.')
screenshot.image.attach(io: placeholder, filename: File.basename(placeholder.path))
placeholder.rewind
screenshot.save!

screenshot = Screenshot.create!(product: knartwork, caption: 'Create complex flows mapped to stardard terminologies.')
screenshot.image.attach(io: placeholder, filename: File.basename(placeholder.path))
placeholder.rewind
screenshot.save!

knartwork_build = Build.create!(
  product: knartwork,
  version: '0.5.1',
  container_repository: 'p3000/knartwork',
  container_tag: 'v0.5.1',
  published_at: now,
  release_notes: 'From product source of the same release tag.',
  permissions: {}
)

cql_translation_service = Product.create!(
  name: 'CQL Translation Product',
  description: 'A microservice wrapper for the CQL to ELM conversion library.',
  user: administrator,
  uri: 'https://marketplace.hspconsortium.org/products/cql-translation-product',
  support_url: 'https://github.com/mitre/cql-translation-product',
  mime_type: 'application/vnd.docker',
  published_at: now,
  visible_at: now
)
cql_translation_service.logo.attach(io: placeholder, filename: File.basename(placeholder.path))
cql_translation_service.save!
placeholder.rewind
ProductLicense.create!(product: cql_translation_service, license: apache20)

screenshot = Screenshot.create!(product: cql_translation_service, caption: 'An API for CQL-to-ELM conversion.')
screenshot.image.attach(io: placeholder, filename: File.basename(placeholder.path))
placeholder.rewind
screenshot.save!

cql_translation_service_build = Build.create!(
  product: cql_translation_service,
  version: '1.0.2',
  container_repository: 'p3000/cql-translation-product/',
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
                                                                                       'products' => { 'read' => true }
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

logica_badge = Badge.create!(name: 'logica', description: "Endorsed by Logica Health.")
intermountain_badge = Badge.create!(name: 'intermountain', description: "Endorsed by Intermountain Healthcare to meet their standards of interoperability.")
