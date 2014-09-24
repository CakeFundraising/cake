class ChangeStatusDefaultForCamapigns < ActiveRecord::Migration
  def up
    change_column :campaigns, :status, :string, default: :pending
  end

  def down
    change_column :campaigns, :status, :string, default: :not_launched
  end
end
