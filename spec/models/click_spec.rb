require 'rails_helper'

describe Click do
  it { should belong_to(:pledge).touch(true) }
  it { should belong_to(:browser) }

  it { should validate_presence_of(:browser_id) }
  it { should validate_presence_of(:pledge_id) }
end
