require 'rails_helper'

describe StripeAccount do
  it { should belong_to(:account) }
end
