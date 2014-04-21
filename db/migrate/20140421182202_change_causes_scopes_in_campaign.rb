class ChangeCausesScopesInCampaign < ActiveRecord::Migration
  def change
    remove_column :campaigns, :scope, :string
    remove_column :campaigns, :cause, :string
    add_column :campaigns, :causes_mask, :integer
    add_column :campaigns, :scopes_mask, :integer
  end
end
