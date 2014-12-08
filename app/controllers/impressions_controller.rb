class ImpressionsController < ApplicationController
  def rendered
    impression = Impression.find(params[:impression_id])
    impression.fully_rendered = true
    impression.browser = current_browser if impression.browser.nil? and current_browser.present?

    if impression.save(validate: false)
      render text: 'Impression rendered.' 
    else
      render text: 'Error when updating impression.' 
    end
  end  
end