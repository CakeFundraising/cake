class InvoiceDecorator < ApplicationDecorator
  delegate_all
  decorates_association :campaign
  decorates_association :sponsor
  decorates_association :fundraiser
  decorates_association :pledge

  def status
    object.status.titleize
  end

  def due
    h.humanized_money_with_symbol object.due
  end

  def click_donation
    h.humanized_money_with_symbol object.click_donation
  end

  def id
    "##{object.id}"
  end
end
