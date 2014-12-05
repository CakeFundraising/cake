class AddAutoShowToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :auto_show, :integer, default: true
  end
end
