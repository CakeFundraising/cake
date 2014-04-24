# Pledge Requests are created when a fundraiser wants a sponsor to pledge his campaign.
# When a sponsor wants a campaign to pledge, he directly creates a Pledge insted of a Pledge Request, 
# that Pledge will appear like a Pending Pledge in the FR dashboard.
class PledgeRequest < ActiveRecord::Base
  include Statusable
  has_statuses :pending, :accepted, :rejected

  belongs_to :sponsor
  belongs_to :campaign
  belongs_to :fundraiser

  validates :sponsor, :campaign, :fundraiser, presence: true
end
