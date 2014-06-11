class CouponDecorator < ApplicationDecorator
  delegate_all

  def expires_at
    object.expires_at.strftime("%B %d, %Y")
  end

  def to_s
  	object.title
  end
end
