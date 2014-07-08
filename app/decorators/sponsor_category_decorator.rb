class SponsorCategoryDecorator < ApplicationDecorator
  delegate_all

  def name
    object.name.titleize
  end

  def range
    "#{h.humanized_money_with_symbol(min_value)} to #{h.humanized_money_with_symbol(max_value)}"
  end

  def min
    h.humanized_money_with_symbol object.min_value
  end

  def max
    h.humanized_money_with_symbol object.max_value
  end
end
