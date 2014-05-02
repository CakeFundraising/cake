@pledges = @sponsors.flat_map do |s|
  create(5, s.pledges) do |p|
    p.mission = Faker::Lorem.sentence
    p.headline = Faker::Lorem.sentence
    p.description = Faker::Lorem.paragraph
    p.amount_per_click = rand(99) + 1
    p.donation_type = Pledge::DONATION_TYPES.sample
    p.total_amount = rand(99999) + 1
    p.website_url = Faker::Internet.domain_name
    p.campaign = @campaigns.sample

    build(2, p.coupons) do |c|
      c.title = Faker::Lorem.sentence
      c.expires_at = Time.now + 3.months
      c.promo_code = rand(9999)
      c.description = Faker::Lorem.paragraph
      c.avatar.store!(File.open(File.join(Rails.root, 'db/seeds/support/images/coupon.jpg')))
      c.qrcode.store!(File.open(File.join(Rails.root, 'db/seeds/support/images/qrcode.jpg')))
    end

    build(2, p.sweepstakes) do |sw|
      sw.winners_quantity = rand(99)
      sw.claim_prize_instructions = Faker::Lorem.paragraph
      sw.title = Faker::Lorem.sentence
      sw.description = Faker::Lorem.paragraph
      sw.avatar.store!(File.open(File.join(Rails.root, 'db/seeds/support/images/coupon.jpg')))
    end
  end
end