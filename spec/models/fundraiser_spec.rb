require 'spec_helper'

describe Fundraiser do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:phone) }
  it { should validate_presence_of(:cause) }

  it { should belong_to(:manager).class_name('User') }
  it { should have_one(:location).dependent(:destroy) }
  it { should have_one(:picture).dependent(:destroy) }
  it { should have_many(:users) }

  it { should accept_nested_attributes_for(:location).update_only(true) }
  it { should accept_nested_attributes_for(:picture).update_only(true) }
end
