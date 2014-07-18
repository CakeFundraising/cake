class AboutController < ApplicationController
  include HighVoltage::StaticPage
 
  CONTENT_PATH = 'about/'

  def page_finder
    page_finder_factory.new(params[:id], CONTENT_PATH)
  end
end
