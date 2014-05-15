class FundraiserDecorator < ApplicationDecorator
  delegate_all

  def to_s
    object.name    
  end  
  
  def causes
    object.causes.join(", ")
  end

  def stripe_account?
    stripe_account.present?
  end
end