class UpdateStatusDefaultsForCampaign < ActiveRecord::Migration
  def up
    change_column :campaigns, :status, :string, default: :incomplete
    change_column :pledges, :status, :string, default: :incomplete
  end

  def down
    change_column :campaigns, :status, :string, default: :uncompleted
    change_column :pledges, :status, :string, default: :uncompleted
  end
end
