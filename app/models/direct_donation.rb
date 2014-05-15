class DirectDonation < ActiveRecord::Base
  belongs_to :campaign

  validates :campaign, :card_token, presence: true
end
