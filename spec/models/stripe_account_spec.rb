require 'spec_helper'

describe StripeAccount do
  it { should belong_to(:account) }
end
