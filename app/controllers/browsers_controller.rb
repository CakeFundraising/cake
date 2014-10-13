class BrowsersController < ApplicationController
  def create
    browser = Browser.new(
      ip: request.remote_ip,
      ua: request.headers['HTTP_USER_AGENT'],
      http_language: request.headers['HTTP_ACCEPT_LANGUAGE'],
      http_encoding: request.headers['HTTP_ACCEPT_ENCODING'],
      plugins: params[:plugins],
      user: current_user
    )

    duplicates = Browser.equal_to(browser)

    if duplicates.any?
      session[:browser_id] = duplicates.first.id unless session[:browser_id].present? or duplicates.count > 1
    else
      browser.save! 
      session[:browser_id] = browser.id
    end
    
    render json: session[:browser_id]
  end

end
