class Browser < ActiveRecord::Base
  belongs_to :user

  validates :ip, :ua, :http_language, :http_encoding, :plugins, presence: true

  scope :equal_to, ->(other){
    where(
      ip: other.ip, 
      ua: other.ua,
      http_encoding: other.http_encoding,
      http_language: other.http_language,
      plugins: other.plugins
    ) 
  }
end
