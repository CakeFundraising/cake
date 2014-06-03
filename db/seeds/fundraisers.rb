@fundraisers = create(5, Fundraiser) do |f, fundraiser_index|
  build(1, f.location, {prebuild: true}) do |l|
    l.address = Faker::Address.street_address
    l.country_code = 'US'
    l.state_code = Faker::Address.state_abbr
    l.zip_code = Faker::Address.zip_code
    l.city = Faker::Address.city
    l.name = Faker::Lorem.sentence
  end

  build(3, f.users) do |u, user_index|
    u.email = "fundraiser_#{fundraiser_index}_user_#{user_index}@example.com"
    u.full_name = Faker::Name.first_name
    u.password = 'password'
    u.roles = [:fundraiser]
    u.confirmed_at = Time.now
    u.provider = User.omniauth_providers.sample
    u.uid = SecureRandom.hex(8)
  end

  f.manager = f.users.first

  f.causes = Fundraiser::CAUSES.sample(3)
  f.min_pledge = Fundraiser::MIN_PLEDGES.sample
  f.min_click_donation = Fundraiser::MIN_CLICK_DONATIONS.sample
  f.manager_name = Faker::Name.name
  f.manager_title = Faker::Name.title
  f.manager_email = Faker::Internet.safe_email
  f.manager_phone = Faker::PhoneNumber.phone_number
  f.name = Faker::Lorem.sentence
  f.mission = Faker::Lorem.paragraph
  f.supporter_demographics = Faker::Lorem.paragraph
  f.phone = Faker::PhoneNumber.phone_number
  f.website = Faker::Internet.domain_name
  f.email = Faker::Internet.safe_email
end

@fundraisers.map(&:users).flatten.each do |user|
  user.create_fundraiser_email_setting
end