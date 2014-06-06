class AddIncreaseRequestedToPledges < ActiveRecord::Migration
  def change
    add_column :pledges, :increase_requested, :boolean, default: false
  end
end
