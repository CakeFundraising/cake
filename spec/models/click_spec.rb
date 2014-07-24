require 'spec_helper'

describe Click do
  it { should belong_to(:pledge) }
  it { should validate_presence_of(:request_ip) }
  it { should validate_presence_of(:user_agent) }
  it { should validate_presence_of(:http_encoding) }
  it { should validate_presence_of(:http_language) }
  it { should validate_presence_of(:pledge) }
end
