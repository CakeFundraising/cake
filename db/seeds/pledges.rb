@pledges = @sponsors.flat_map do |s|
  create(5, s.pledges) do |p|
    p.mission = Faker::Lorem.sentence
    p.headline = Faker::Lorem.sentence
    p.description = Faker::Lorem.paragraph
    p.amount_per_click = rand(99)
    p.donation_type = Pledge::DONATION_TYPES.sample
    p.total_amount = rand(99999)
    p.website_url = Faker::Internet.domain_name
    p.campaign = @campaigns.sample

    # build(2, p.coupons) do |c|
    #   c.title = Faker::Lorem.sentence
    #   c.expires_at = Time.now + 3.months
    #   c.promo_code = rand(9999)
    #   c.description = Faker::Lorem.paragraph
    #   c.avatar "MyString"
    #   c.qrcode "MyString"
    # end
  end
end