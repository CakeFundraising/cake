class SponsorDecorator < ApplicationDecorator
  delegate_all

  def scopes
    object.scopes.join(", ")
  end

  def website
    "http://#{object.website}"
  end

  def to_s
    object.name
  end
end
