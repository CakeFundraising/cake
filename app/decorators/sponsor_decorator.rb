class SponsorDecorator < ApplicationDecorator
  delegate_all

  def scopes
    object.scopes.join(", ")
  end
end
