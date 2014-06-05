class AddMaxClicksToPledges < ActiveRecord::Migration
  def change
    add_column :pledges, :max_clicks, :integer, default: 0
  end
end
