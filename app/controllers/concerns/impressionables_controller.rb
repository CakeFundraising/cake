module ImpressionablesController
  extend ActiveSupport::Concern

  included do
    unless Rails.env.test?
      before_action :create_impression, only: :show
    end
  end

  protected

  def create_impression
    view = "#{controller_name}/#{action_name}"

    unless current_browser.blank? or resource.impressions.find_with(view, current_browser).any? or request.headers['HTTP_USER_AGENT'] == "facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)"   
      @impression = resource.impressions.create!(view: view, browser: current_browser)
    end
  end
end