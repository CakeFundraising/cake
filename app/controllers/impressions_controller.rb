class ImpressionsController < ApplicationController
  def rendered
    plugins = params[:browser_plugins].blank? ? nil : params[:browser_plugins]

    impression = Impression.find(params[:impression_id])

    impression.browser_plugins = plugins.join(',')
    impression.fully_rendered = true

    if impression.save(validate: false)
      render text: 'Impression rendered.' 
    else
      render text: 'Error when updating impression.' 
    end
  end  
end