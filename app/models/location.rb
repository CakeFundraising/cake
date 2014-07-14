class Location < ActiveRecord::Base
  belongs_to :locatable, polymorphic: true

  validates :country_code, :state_code, :city, :address, :zip_code, presence: true

  COUNTRIES = Carmen::Country.all.map(&:name)

  def country
    Carmen::Country.coded(self.country_code)
  end

  def state
    country.subregions.coded(self.state_code)
  end

  def to_s
    "#{address}, #{city}, #{state.name}, #{country.name}"
  end
end
