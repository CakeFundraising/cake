class AddProcessedStatusToPledges < ActiveRecord::Migration
  def change
    add_column :pledges, :processed_status, :string, default: 'unprocessed'
  end
end
