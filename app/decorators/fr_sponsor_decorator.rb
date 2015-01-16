class FrSponsorDecorator < ApplicationDecorator
  delegate_all
  decorates_association :picture

  def to_s
    object.name
  end

  def location
    "#{object.location.city}, #{object.location.state_code}"
  end
end
