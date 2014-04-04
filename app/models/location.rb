class Location < ActiveRecord::Base
  belongs_to :locatable, polymorphic: true

  validates :country, :state, :city, :address, :name, presence: true

  COUNTRIES = Carmen::Country.all.map(&:name)

  def to_s
    "#{address}, #{state}, #{country}"
  end
end
