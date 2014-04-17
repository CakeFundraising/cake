class FundraiserDecorator < ApplicationDecorator
  delegate_all

  def to_s
    object.name    
  end  
end