class Click < ActiveRecord::Base
  belongs_to :pledge, counter_cache: true
  belongs_to :browser

  validate :unique_click

  private

  def unique_click
    errors.add(:clicks, "You can click in a pledge only once.") if pledge.present? and pledge.click_exists?(self)
  end
end
