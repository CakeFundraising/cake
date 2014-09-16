class AddProviderToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :provider, :string
    #add_column :videos, :thumbnail, :string
  end
end
