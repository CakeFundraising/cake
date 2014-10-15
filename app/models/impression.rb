class Impression < ActiveRecord::Base
  belongs_to :impressionable, polymorphic: true, counter_cache: true
  belongs_to :browser

  validates :view, presence: true
  validate :unique_impression

  scope :latest, ->{ order(created_at: :desc) }

  scope :find_with, ->(view_name, browser){
    where(view: view_name, browser_id: browser.id)
  }

  private

  def unique_impression
    errors.add(:impressions, "Impression already tracked.") if impressionable.present? and impressionable.impressions.exists?(self)
  end
end