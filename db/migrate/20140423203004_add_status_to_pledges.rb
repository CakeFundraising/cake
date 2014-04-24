class AddStatusToPledges < ActiveRecord::Migration
  def change
    add_column :pledges, :status, :string, default: :pending
    add_column :pledges, :activity_status, :string, default: :inactive
  end
end
