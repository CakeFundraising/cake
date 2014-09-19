module Cause
  extend ActiveSupport::Concern

  # DON'T CHANGE THE ORDER, IF YOU NEED TO ADD JUST APPEND TO THE LIST
  CAUSES_HIERARCHY = {
    disaster_and_emergency: [
      "International Relief", 
      "US Relief"
    ],

    causes_and_organizations: [
      "Alternative Media & Web",
      "Animals & Pets",
      "Business & Entrepeneurs",
      "Community Events & Festivals",
      "Community Organizations",
      "Community & Social Services",
      "Creative Arts & Music",
      "Colleges, Schools & Alumni",
      "Education & Learning",
      "Environment & Conservation",
      "Food & Hunger",
      "Freedom & Liberty",
      "Group & Individual Projects",
      "Health & Medicine",
      "Individuals & Families in Need",
      "Inventions & Technology",
      "Memorials, Tributes & Awards",
      "Military & Veterans",
      "Politics & Campaigns",
      "Science & Research",
      "Sports, Teams & Competitions"
      
      #"Food & Hunger",
      #"Environment & Conservation",
      #"Community Organizations",
      #"Health & Medicine",
      #"Education & Learning",
      #"Economic Development",
      #"Freedom & Liberty",
      #"Alternative Media & Web",
      #"Creative Arts & Music",
      #"Community Events & Festivals",
      #"Politics & Campaigns",
      #"Individuals & Families in Need",
      #"Animals & Pets",
      #"Sports, Teams & Competitions",
      #"Business & Entrepeneurs",
      #"Group & Individual Projects",
      #"Military & Veterans",
      #"Memorials, Tributes & Awards",
      #"Science & Research",
      #"Inventions & Technology",
      #"Community & Social Services"
    ],
    building_and_capital_projects: [
      "Arts & Culture",
      "Churches & Religion",
      "Education & Schools",
      "Conservation & Nature",
      "Medical, Hospitals & Clinics",
      "Sports, Parks & Recreation",
      "Walks, Roads & Bridges"
      
      #"Education & Schools",
      #"Sports, Parks & Recreation",
      #"Medical, Hospitals & Clinics",
      #"Churches & Religion",
      #"Arts & Culture",
      #"Walks, Roads & Bridges",
      #"Infrastructure & Utility"
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