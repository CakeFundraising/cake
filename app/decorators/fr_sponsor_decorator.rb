class FrSponsorDecorator < ApplicationDecorator
  delegate_all
  decorates_association :picture

  def to_s
    object.name
  end

  def website
    h.auto_attr_link website_url, target: :_blank
  end

  def website_url
    (object.website_url=~/^https?:\/\//).nil? ? "http://#{object.website_url}" : object.website_url
  end

  def location
    "#{object.location.city}, #{object.location.state_code}"
  end
end
