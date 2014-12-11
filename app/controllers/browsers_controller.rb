class BrowsersController < ApplicationController
  def fingerprint
    @fingerprint = params[:fingerprint]
    @evercookie_token = params[:ec_token]

    if current_browser.present?
      render text: current_browser.id
    else
      fingerprinted = Browser.with_fingerprint(@fingerprint)
      tokenized = Browser.with_token(@evercookie_token)

      if fingerprinted.any? #Incognito/Private session 
        # Distinct token same fingerprint
        browser = fingerprinted.last
        reset_evercookie(browser)
        render text: browser.id
      elsif tokenized.any?
        # Distinct fingerprint same token
        browser = update_browser(tokenized.last)
        reset_evercookie(browser)
        render text: browser.id
      else
        new_browser = create_browser
        render text: new_browser.id
      end
    end

  end

  private

  def create_browser
    browser = Browser.create(fingerprint: @fingerprint, token: @evercookie_token, user_id: current_user)
    reset_evercookie(browser)
    browser
  end

  def update_browser(browser)
    browser.update(fingerprint: @fingerprint, token: @evercookie_token, user_id: current_user)
    browser.reload
  end

  def reset_evercookie(browser)
    set_evercookie(:cfbid, browser.token)
  end
end
