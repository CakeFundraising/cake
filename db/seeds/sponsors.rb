@sponsors = create(5, Sponsor) do |f, sponsor_index|
  build(1, f.location, {prebuild: true}) do |l|
    l.address = Faker::Address.street_address
    l.country_code = 'US'
    l.state_code = Faker::Address.state_abbr
    l.zip_code = Faker::Address.zip_code
    l.city = Faker::Address.city
    l.name = Faker::Lorem.sentence
  end

  build(3, f.users) do |u, user_index|
    u.email = "sponsor_#{sponsor_index}_user_#{user_index}@example.com"
    u.full_name = Faker::Name.first_name
    u.password = 'password'
    u.roles = [:sponsor]
    u.confirmed_at = Time.now
    u.provider = User.omniauth_providers.sample
    u.uid = SecureRandom.hex(8)
  end

  f.manager = f.users.first

  f.mission = Faker::Lorem.paragraph
  f.customer_demographics = Faker::Lorem.paragraph
  f.causes = Sponsor::CAUSES.sample(3)
  f.scopes = Sponsor::SCOPES.sample(2)
  f.cause_requirements = [Sponsor::CAUSE_REQUIREMENTS.sample]
  f.manager_name = Faker::Name.name
  f.manager_title = Faker::Name.title
  f.manager_email = Faker::Internet.safe_email
  f.manager_phone = Faker::PhoneNumber.phone_number
  f.name = Faker::Lorem.sentence
  f.phone = Faker::PhoneNumber.phone_number
  f.website = Faker::Internet.domain_name
  f.email = Faker::Internet.safe_email
end

@sponsors.map(&:users).flatten.each do |user|
  user.create_sponsor_email_setting
end