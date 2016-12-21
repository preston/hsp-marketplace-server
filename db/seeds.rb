google = IdentityProvider.create_with(
    name: 'Google',
    client_id: '418783041492-si96ptie7gdbn46184e86thjmee3nj88.apps.googleusercontent.com',
    client_secret: 'MoyTrvZ0t4FFC6_LVGnN2TYo',
    scopes: 'openid email profile'
).find_or_create_by(issuer: 'https://accounts.google.com')
google.reconfigure
google.save!

# live = System::IdentityProvider.create_with(
#     name: 'Microsoft Live',
#     client_id: '0000000040193B01',
#     client_secret: '5J4ZxPQb22bXxvj1i-eqaHQILqKKRb2-',
#     alternate_client_id: '00000000-0000-0000-0000-000040193B01',
#     scopes: 'openid email profile'
# ).find_or_create_by(issuer: 'https://login.live.com')
# live.reconfigure
# live.save!

Client.create!(
    name: "Preston's Client",
    launch_url: 'https://marketplace.healthcreek.org/index.html',
    icon_url: 'http://marketplace.healthcreek.org/app/images/textures/tileable_wood_texture.png',
    available: true
)

administrator_role = Role.create!(
    name: 'Administrator',
    code: 'administrator'
)

default_role = Role.create!(
    name: 'Default',
    code: 'default'
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
    # Appointment.create!(entity: u, role: default_role)
end
