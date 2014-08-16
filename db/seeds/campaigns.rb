@campaigns = @fundraisers.flat_map do |f|
  create(3, f.campaigns) do |c|
    c.title = Faker::Lorem.sentence
    c.launch_date = Time.now - 2.weeks
    c.end_date = Time.now + 4.months
    c.goal = rand(999) + 1
    c.main_cause = Campaign::CAUSES.sample
    c.causes = Campaign::CAUSES.sample(5)
    c.scopes = Campaign::SCOPES.sample(2)
    c.headline = Faker::Lorem.sentence
    c.mission = Faker::Lorem.paragraph
    c.story = Faker::Lorem.paragraph
    c.status = :launched

    build(3, c.sponsor_categories) do |sc, i|
      i = i + 1
      sc.name = Faker::Lorem.sentence
      sc.min_value_cents = i * 10000
      sc.max_value_cents = (i+0.5) * 10000 
      sc.position = i
    end
  end
end

#Past Campaigns
@past_campaigns = @fundraisers.flat_map do |f|
  create(2, f.campaigns) do |pc|
    pc.title = Faker::Lorem.sentence
    pc.launch_date = Time.now - 4.months
    pc.end_date = Time.now - 2.months
    pc.goal = rand(999) + 1
    pc.main_cause = Campaign::CAUSES.sample
    pc.causes = Campaign::CAUSES.sample(5)
    pc.scopes = Campaign::SCOPES.sample(2)
    pc.headline = Faker::Lorem.sentence
    pc.mission = Faker::Lorem.paragraph
    pc.story = Faker::Lorem.paragraph
    pc.status = :past

    build(3, pc.sponsor_categories) do |sc, i|
      i = i + 1
      sc.name = Faker::Lorem.sentence
      sc.min_value_cents = i * 10000
      sc.max_value_cents = (i+0.5) * 10000
      sc.position = i
    end
  end
end

puts "#{@campaigns.count} Active Campaigns & #{@past_campaigns.count} Past Campaigns created."