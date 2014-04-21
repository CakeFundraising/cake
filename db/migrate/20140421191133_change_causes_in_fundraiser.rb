class ChangeCausesInFundraiser < ActiveRecord::Migration
  def change
    remove_column :fundraisers, :cause, :string
    add_column :fundraisers, :causes_mask, :integer
  end
end
