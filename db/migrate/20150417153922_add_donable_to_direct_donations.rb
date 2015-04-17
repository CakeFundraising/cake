class AddDonableToDirectDonations < ActiveRecord::Migration
  def change
    add_reference :direct_donations, :donable, polymorphic: true, index: true
    remove_column :direct_donations, :fundraiser_id, :integer
  end
end
