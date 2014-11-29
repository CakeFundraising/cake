class BrowsersController < ApplicationController
  def fingerprint
    if current_browser.fingerprint.blank?
      save_fingerprint(params[:fingerprint]) ? render(text: 'Fingerprint saved.') : render(text: 'Error saving fingerprint')
    else
      render text: 'Current Browser already fingerprinted.'
    end
  end

  private

  def save_fingerprint(fingerprint)
    fingerprinted = Browser.with_fingerprint(fingerprint)

    unless fingerprinted.any?
      current_browser.update_attribute(:fingerprint, fingerprint)
    else
      override_evercookie(:cfbid, fingerprinted.first.token)
      true
    end
  end
end
