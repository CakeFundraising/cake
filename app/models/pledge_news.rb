class PledgeNews < ActiveRecord::Base
  include Picturable
  include ExtraClickable

  belongs_to :pledge
  has_one :sponsor, through: :pledge, source_type: 'Sponsor'

  scope :latest, ->{ order(created_at: :desc) }

  validates :headline, :story, :url, :pledge_id, presence: true

  delegate :city, :state_code, to: :sponsor

  def active?
    self.pledge.active?
  end
end
