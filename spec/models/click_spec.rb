require 'spec_helper'

describe Click do
  it { should belong_to(:pledge) }
  it { should belong_to(:browser) }
end
