class ChangeTypeToVideosAutoShow < ActiveRecord::Migration
  def up
    remove_column :videos, :auto_show, :integer
    add_column :videos, :auto_show, :boolean, default: true
  end

  def down
    remove_column :videos, :auto_show, :boolean
    add_column :videos, :auto_show, :integer
  end
end
