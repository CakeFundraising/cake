class CakesterRequestDecorator < ApplicationDecorator
  delegate_all
  decorates_association :campaign
  decorates_association :cakester
  decorates_association :fundraiser
  decorates_association :pledge

  def end_date
    campaign.end_date
  end

  def cause
    object.main_cause
  end

  def scopes
    object.scopes.join(", ")
  end

  def rate
    "#{object.rate}%"
  end

  def hero
    h.b object.hero
  end

  def status
    object.status.upcase
  end

  def kind
    'Exclusive'
  end
end
