# Pledge Requests are created when a fundraiser wants a sponsor to pledge his campaign.
# When a sponsor wants a campaign to pledge, he directly creates a Pledge insted of a Pledge Request, 
# that Pledge will appear like a Pending Pledge in the FR dashboard.
class PledgeRequest < ActiveRecord::Base
  include Statusable
  has_statuses :pending, :accepted, :rejected

  attr_accessor :message

  belongs_to :sponsor
  belongs_to :campaign
  belongs_to :fundraiser

  validates :sponsor, :campaign, :fundraiser, presence: true

  scope :by_pledge, ->(pledge){ where(sponsor_id: pledge.sponsor.id, campaign_id: pledge.campaign.id, fundraiser_id: pledge.fundraiser.id) }

  def notify_sponsor(message)
    sponsor.users.each do |user|
      PledgeNotification.new_pledge_request(self, message).deliver if user.sponsor_email_setting.new_pledge_request
    end
  end

  def notify_rejection(message)
    PledgeNotification.rejected_pledge_request(self, message).deliver
  end
end
