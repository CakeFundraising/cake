require 'spec_helper'

describe Click do
  it { should belong_to(:pledge) }
  it { should validate_presence_of(:request_ip) }
  it { should validate_presence_of(:pledge) }
end
