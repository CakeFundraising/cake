class Click < ActiveRecord::Base
  belongs_to :pledge, counter_cache: true

  validates :request_ip, :pledge, presence: true
  validates_associated :pledge
  validate :unique_click

  private

  def unique_click
    errors.add(:clicks, "You can click in a pledge only once.") if pledge.present? and pledge.have_donated?(self.request_ip)
  end
end
