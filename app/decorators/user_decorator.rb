class UserDecorator < ApplicationDecorator
  delegate_all

  def to_s
    object.full_name.titleize
  end
end
