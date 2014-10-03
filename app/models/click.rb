class Click < ActiveRecord::Base
  belongs_to :pledge, counter_cache: true

  validates :request_ip, :user_agent, :http_encoding, :http_language, :pledge, presence: true
  #validates_associated :pledge
  validate :unique_click

  scope :equal_to, ->(click){
    where(
      request_ip: click.request_ip, 
      user_agent: click.user_agent,
      http_encoding: click.http_encoding,
      http_language: click.http_language,
      browser_plugins: click.browser_plugins
    ) 
  } 

  def browser
    "#{user_agent}|#{http_accept}|#{http_encoding}|#{http_language}|#{browser_plugins}"
  end

  def self.build_with(pledge, request, plugins=nil)
    new(
      request_ip: request.remote_ip,
      user_agent: request.headers['HTTP_USER_AGENT'],
      http_encoding: request.headers['HTTP_ACCEPT_ENCODING'],
      http_language: request.headers['HTTP_ACCEPT_LANGUAGE'],
      browser_plugins: plugins.blank? ? nil : plugins, #set as nil not as ""
      pledge: pledge
    )
  end

  private

  def unique_click
    errors.add(:clicks, "You can click in a pledge only once.") if pledge.present? and pledge.click_exists?(self)
  end
end
