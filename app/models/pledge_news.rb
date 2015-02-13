class PledgeNews < ActiveRecord::Base
  include Picturable

  belongs_to :pledge
  has_one :sponsor, through: :pledge, source_type: 'Sponsor'

  scope :latest, ->{ order(created_at: :desc) }

  validates :headline, :story, :url, presence: true

  delegate :city, :state_code, to: :sponsor
end
