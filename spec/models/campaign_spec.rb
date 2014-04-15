require 'spec_helper'

describe Campaign do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:launch_date) }
  it { should validate_presence_of(:end_date) }
  it { should validate_presence_of(:cause) }
  it { should validate_presence_of(:headline) }
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:fundraiser) }

  it { should belong_to(:fundraiser) }
  it { should have_one(:picture).dependent(:destroy) }
  it { should have_many(:sponsor_categories).dependent(:destroy) }

  it { should accept_nested_attributes_for(:picture).update_only(true) }
end
