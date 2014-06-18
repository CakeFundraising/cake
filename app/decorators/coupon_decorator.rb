class CouponDecorator < ApplicationDecorator
  delegate_all
  decorates_association :pledge
  decorates_association :sponsor

  def trunc_description
    h.truncate(object.description, length: 50)
  end

  def expires_at
    object.expires_at.strftime("%B %d, %Y")
  end

  def to_s
  	object.title
  end
end
