class ImpressionsController < ApplicationController
  def rendered
    impression = Impression.find(params[:impression_id])
    impression.fully_rendered = true

    if impression.save(validate: false)
      render text: 'Impression rendered.' 
    else
      render text: 'Error when updating impression.' 
    end
  end  
end