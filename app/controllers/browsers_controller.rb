class BrowsersController < ApplicationController
  def fingerprint
    fingerprint = params[:fingerprint]

    if current_browser.present? #Present Browser
      if current_browser.fingerprint.blank?
        save_fingerprint(fingerprint) ? puts('Fingerprint saved.') : puts('Error saving fingerprint')
      else
        puts 'Current Browser already fingerprinted.'
      end
      render nothing: true
    else #New browser
      if evercookie_is_set?(:cfbid)
        puts 'Evercookie already set.'
        render nothing: true
      else
        @evercookie_token = loop do
          random_token = SecureRandom.urlsafe_base64(nil, false)
          break random_token unless Browser.exists?(token: random_token)
        end

        unless @evercookie_token.nil? or Browser.exists?(fingerprint: fingerprint)
          Browser.create(token: @evercookie_token, fingerprint: fingerprint)
          render text: @evercookie_token
        else
          render nothing: true
        end
      end
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
