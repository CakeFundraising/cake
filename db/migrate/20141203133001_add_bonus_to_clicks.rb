class AddBonusToClicks < ActiveRecord::Migration
  def change
    add_column :clicks, :bonus, :boolean, default: false
  end
end
