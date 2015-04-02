class CreateCakesterCommissions < ActiveRecord::Migration
  def change
    create_table :cakester_commissions do |t|
      t.string :deal_type, default: 'flat'
      t.integer :percentage_value, default: 0
      t.integer :flat_value, default: 0
      t.references :commissionable, polymorphic: true

      t.timestamps null: false
    end

    remove_column :campaigns, :cakester_commission_percentage, :integer
  end
end
