require 'spec_helper'

describe Invoice do
  it { should belong_to(:pledge) }
  it { should have_one(:campaign).through(:pledge) }
  it { should have_one(:fundraiser).through(:campaign) }
  it { should have_one(:sponsor).through(:pledge) }
end
