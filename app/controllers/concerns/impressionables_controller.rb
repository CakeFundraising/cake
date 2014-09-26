module ImpressionablesController
  extend ActiveSupport::Concern

  included do
    before_action :create_impression, only: :show
  end

  protected

  def create_impression
    @impression = resource.impressions.create!(
      view: "#{controller_name}/#{action_name}",
      ip: request.remote_ip,
      user_agent: request.headers['HTTP_USER_AGENT'],
      http_encoding: request.headers['HTTP_ACCEPT_ENCODING'],
      http_language: request.headers['HTTP_ACCEPT_LANGUAGE']
    ) unless resource.impressions.find_with("#{controller_name}/#{action_name}", request).any?    
  end
end