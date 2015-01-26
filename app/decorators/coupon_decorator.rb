class CouponDecorator < ApplicationDecorator
  delegate_all
  decorates_association :pledge
  decorates_association :sponsor
  decorates_association :picture

  def trunc_title
    h.truncate(object.title, length: 37).html_safe
  end

  def trunc_description
    h.truncate(object.description, length: 100).html_safe
  end

  def expires_at
    object.expires_at.strftime("%B %d, %Y")
  end

  def expires_at_american
    object.expires_at.strftime("%m/%d/%Y") unless object.expires_at.nil?
  end

  def to_s
  	object.title
  end
end
