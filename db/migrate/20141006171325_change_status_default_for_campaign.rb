class ChangeStatusDefaultForCampaign < ActiveRecord::Migration
  def up
    change_column :campaigns, :status, :string, default: :uncompleted
    change_column :pledges, :status, :string, default: :uncompleted
  end

  def down
    change_column :campaigns, :status, :string, default: :pending
    change_column :pledges, :status, :string, default: :pending
  end
end
