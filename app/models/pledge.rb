class Pledge < ActiveRecord::Base
  attr_accessor :step 
  
  belongs_to :sponsor
  belongs_to :campaign
  has_one :fundraiser, through: :campaign
  has_one :picture, as: :picturable, dependent: :destroy
  has_one :video, as: :recordable, dependent: :destroy

  monetize :amount_per_click_cents, numericality: {greater_than_or_equal_to: 1, less_than_or_equal_to: 1000}
  monetize :total_amount_cents, numericality: {greater_than_or_equal_to: 1}

  validates :amount_per_click, :total_amount, :donation_type, :campaign, :website_url, presence: true
  validates :terms, acceptance: true
end
