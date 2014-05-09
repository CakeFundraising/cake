@campaigns = @fundraisers.flat_map do |f|
  create(3, f.campaigns) do |c|
    c.title = Faker::Lorem.sentence
    c.launch_date = Time.now - 2.weeks
    c.end_date = Time.now + 4.months
    c.causes = Campaign::CAUSES.sample(5)
    c.scopes = Campaign::SCOPES.sample(2)
    c.headline = Faker::Lorem.sentence
    c.story = Faker::Lorem.paragraph

    build(2, c.sponsor_categories) do |sc, i|
      i = i + 1
      sc.name = Faker::Lorem.sentence
      sc.min_value_cents = i * 1000
      sc.max_value_cents = (i+0.5) * 1000 
    end
  end
end