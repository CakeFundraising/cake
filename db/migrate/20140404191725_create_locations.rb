class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :address
      t.string :country_code
      t.string :state_code
      t.string :zip_code
      t.string :city
      t.references :locatable, polymorphic: true, index: true
      t.string :name

      t.timestamps
    end
  end
end
