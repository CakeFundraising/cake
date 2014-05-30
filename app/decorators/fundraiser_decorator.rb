class FundraiserDecorator < ApplicationDecorator
  delegate_all

  def to_s
    object.name    
  end  
  
  def causes
    object.causes.join(", ")
  end
end