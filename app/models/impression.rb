class Impression < ActiveRecord::Base
  belongs_to :impressionable, polymorphic: true

  validates :view, :ip, :user_agent, :http_encoding, :http_language, presence: true
  validate :unique_impression

  scope :latest, ->{ order(created_at: :desc) }

  # scope :equal_to, ->(impression){
  #   where(
  #     ip: impression.request_ip, 
  #     user_agent: impression.user_agent,
  #     http_encoding: impression.http_encoding,
  #     http_language: impression.http_language,
  #     browser_plugins: impression.browser_plugins
  #   ) 
  # }

  scope :find_by_request, ->(request){
    where(
      ip: request.remote_ip,
      user_agent: request.headers['HTTP_USER_AGENT'],
      http_encoding: request.headers['HTTP_ACCEPT_ENCODING'],
      http_language: request.headers['HTTP_ACCEPT_LANGUAGE']
    ).latest
  }
  
  scope :find_with, ->(view_name, request){
    where(view: view_name).find_by_request(request)
  }

  private

  def unique_impression
    errors.add(:impressions, "Impression already tracked.") if impressionable.present? and impressionable.impressions.exists?(self)
  end
end