@pledges = @sponsors.flat_map do |s|
  create(8, s.pledges) do |p|
    campaign = @campaigns.sample

    p.name = Faker::Lorem.sentence
    p.mission = Faker::Lorem.sentence
    p.headline = Faker::Lorem.sentence
    p.description = Faker::Lorem.paragraph
    p.amount_per_click = rand(9) + 1
    p.total_amount = campaign.sponsor_categories.maximum(:max_value_cents)/100 - 1
    p.website_url = "http://#{Faker::Internet.domain_name}"
    p.campaign = campaign

    build(2, p.coupons) do |c|
      c.title = Faker::Lorem.sentence
      c.expires_at = Time.now + 3.months
      c.promo_code = rand(9999)
      c.description = Faker::Lorem.paragraph
      c.merchandise_categories = Coupon::CATEGORIES.sample(2)
    end
  end
end

#Past Pledges
@past_pledges = @sponsors.flat_map do |s|
  create(6, s.pledges) do |p|
    campaign = @past_campaigns.sample

    p.name = Faker::Lorem.sentence
    p.mission = Faker::Lorem.sentence
    p.headline = Faker::Lorem.sentence
    p.description = Faker::Lorem.paragraph
    p.amount_per_click = rand(9) + 1
    p.total_amount = campaign.sponsor_categories.maximum(:max_value_cents)/100 - 1
    p.website_url = "http://#{Faker::Internet.domain_name}"
    p.campaign = campaign
    p.status = :past

    build(2, p.coupons) do |c|
      c.title = Faker::Lorem.sentence
      c.expires_at = Time.now + 3.months
      c.promo_code = rand(9999)
      c.description = Faker::Lorem.paragraph
      c.merchandise_categories = Coupon::CATEGORIES.sample(2)
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