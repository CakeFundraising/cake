require 'spec_helper'

describe Browser do
  it { should belong_to(:user) }
  it { should have_many(:clicks).dependent(:destroy) }
  it { should have_many(:bonus_clicks).dependent(:destroy) }

  it { should validate_presence_of(:token) }
  it { should validate_presence_of(:fingerprint) }
end
