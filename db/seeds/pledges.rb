@pledges = @sponsors.flat_map do |s|
  create(3, s.pledges) do |p|
    campaign = @campaigns.sample

    p.mission = Faker::Lorem.sentence
    p.headline = Faker::Lorem.sentence
    p.description = Faker::Lorem.paragraph
    p.amount_per_click = rand(99) + 1
    p.total_amount = campaign.sponsor_categories.maximum(:max_value_cents)/100 - 1
    p.website_url = Faker::Internet.domain_name
    p.campaign = campaign

    build(2, p.coupons) do |c|
      c.title = Faker::Lorem.sentence
      c.expires_at = Time.now + 3.months
      c.promo_code = rand(9999)
      c.description = Faker::Lorem.paragraph
      c.avatar = Rack::Test::UploadedFile.new(File.join(Rails.root, 'db/seeds/support/images/coupon.jpg'))
      c.qrcode = Rack::Test::UploadedFile.new(File.join(Rails.root, 'db/seeds/support/images/qrcode.jpg'))
      c.merchandise_categories = Coupon::CATEGORIES.sample(2)
    end

    # build(2, p.sweepstakes) do |sw|
    #   sw.winners_quantity = rand(99)
    #   sw.claim_prize_instructions = Faker::Lorem.paragraph
    #   sw.title = Faker::Lorem.sentence
    #   sw.description = Faker::Lorem.paragraph
    #   sw.avatar.store!(File.open(File.join(Rails.root, 'db/seeds/support/images/coupon.jpg')))
    # end

    build(1, p.picture, {prebuild: true}) do |pic|
      pic.avatar = Rack::Test::UploadedFile.new(File.join(Rails.root, "db/seeds/support/images/avatar.jpg"))
      pic.banner = Rack::Test::UploadedFile.new(File.join(Rails.root, "db/seeds/support/images/banner.jpg"))
    end
  end
end

#Past Pledges
@past_pledges = @sponsors.flat_map do |s|
  create(2, s.pledges) do |p|
    campaign = @past_campaigns.sample

    p.mission = Faker::Lorem.sentence
    p.headline = Faker::Lorem.sentence
    p.description = Faker::Lorem.paragraph
    p.amount_per_click = rand(99) + 1
    p.total_amount = campaign.sponsor_categories.maximum(:max_value_cents)/100 - 1
    p.website_url = Faker::Internet.domain_name
    p.campaign = campaign
    p.status = :accepted

    build(2, p.coupons) do |c|
      c.title = Faker::Lorem.sentence
      c.expires_at = Time.now + 3.months
      c.promo_code = rand(9999)
      c.description = Faker::Lorem.paragraph
      c.avatar = Rack::Test::UploadedFile.new(File.join(Rails.root, 'db/seeds/support/images/coupon.jpg'))
      c.qrcode = Rack::Test::UploadedFile.new(File.join(Rails.root, 'db/seeds/support/images/qrcode.jpg'))
      c.merchandise_categories = Coupon::CATEGORIES.sample(2)
    end

    # build(2, p.sweepstakes) do |sw|
    #   sw.winners_quantity = rand(99)
    #   sw.claim_prize_instructions = Faker::Lorem.paragraph
    #   sw.title = Faker::Lorem.sentence
    #   sw.description = Faker::Lorem.paragraph
    #   sw.avatar.store!(File.open(File.join(Rails.root, 'db/seeds/support/images/coupon.jpg')))
    # end

    build(1, p.picture, {prebuild: true}) do |pic|
      pic.avatar = Rack::Test::UploadedFile.new(File.join(Rails.root, "db/seeds/support/images/avatar.jpg"))
      pic.banner = Rack::Test::UploadedFile.new(File.join(Rails.root, "db/seeds/support/images/banner.jpg"))
    end

    build(1, p.build_invoice, {prebuild: true}) do |inv|
      inv.clicks = rand(99999999)
      inv.click_donation_cents = rand(999)
      inv.due_cents = inv.clicks*inv.click_donation_cents
      inv.due_currency = 'USD'
      inv.status = [:due_to_pay, :paid].sample
    end
  end
end

puts "#{@pledges.count} Active pledges & #{@past_pledges.count} Past pledges created."