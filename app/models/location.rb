class Location < ActiveRecord::Base
  belongs_to :locatable, polymorphic: true

  validates :country_code, :state_code, :city, :address, presence: true, unless: :new_record?

  COUNTRIES = Carmen::Country.all.map(&:name)

  def country
    Carmen::Country.coded(self.country_code)
  end

  def state
    country.subregions.coded(self.state_code)
  end

  def to_s
    "#{address}, #{state.name}, #{country.name}"
  end
end
