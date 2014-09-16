
module Formats
  extend ActiveSupport::Concern

  EMAIL_REGEX = /\A([\w\.%\+\-]+)@([\w\-]+\.)+([a-z]{2,})\z/i
  ZIP_CODE_REGEX = /\A(\d{5})(-\d{4})?\z/
  DOMAIN_NAME_REGEX = URI::ABS_URI
end