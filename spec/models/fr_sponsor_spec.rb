require 'spec_helper'

describe FrSponsor do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:website_url) }

  it { should belong_to(:fundraiser) }
  it { should have_one(:location).dependent(:destroy) }
  it { should have_one(:picture).dependent(:destroy) }
  it { should have_many(:quick_pledges).dependent(:destroy) }
  it { should have_many(:campaigns).through(:quick_pledges) }

  it { should accept_nested_attributes_for(:location).update_only(true) }
  it { should accept_nested_attributes_for(:picture).update_only(true) }
end
