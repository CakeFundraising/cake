module Cause
  extend ActiveSupport::Concern

  # DON'T CHANGE THE ORDER, IF YOU NEED TO ADD JUST APPEND TO THE LIST
  CAUSES_HIERARCHY = {
    disaster_and_emergency_relief: ["International Relief", "US Relief"],
    building_and_community_projects: [
      "Education & Schools",
      "Sports, Parks & Recreation",
      "Medical, Hospitals & Clinics",
      "Churches & Religion",
      "Arts & Culture",
      "Walks, Roads & Bridges",
      "Infrastructure & Utility"
    ],
    causes_and_organizations: [
      "Food & Hunger",
      "Environment & Conservation",
      "Community Organizations",
      "Health & Medicine",
      "Education & Learning",
      "Economic Development",
      "Freedom & Liberty",
      "Alternative Media & Web",
      "Creative Arts & Music",
      "Community Events & Festivals",
      "Politics & Campaigns",
      "Individuals & Families in Need",
      "Animals & Pets",
      "Sports, Teams & Competitions",
      "Business & Entrepeneurs",
      "Group & Individual Projects",
      "Military & Veterans",
      "Memorials, Tributes & Awards",
      "Science & Research",
      "Inventions & Technology",
      "Community & Social Services"
    ]
  }

  CAUSES = CAUSES_HIERARCHY.values.flatten

  def causes=(causes)
    causes = causes.split(",") if causes.is_a?(String)
    self.causes_mask = (causes & CAUSES).map { |r| 2**CAUSES.index(r) }.inject(0, :+)
  end

  def causes
    CAUSES.reject do |r|
      ((causes_mask.to_i || 0) & 2**CAUSES.index(r)).zero?
    end
  end

  def has_cause?(cause)
    causes.include?(cause)
  end
end