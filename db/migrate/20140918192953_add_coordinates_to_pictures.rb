class AddCoordinatesToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :avatar_crop_x, :integer
    add_column :pictures, :avatar_crop_y, :integer
    add_column :pictures, :avatar_crop_w, :integer
    add_column :pictures, :avatar_crop_h, :integer
    
    add_column :pictures, :banner_crop_x, :integer
    add_column :pictures, :banner_crop_y, :integer
    add_column :pictures, :banner_crop_w, :integer
    add_column :pictures, :banner_crop_h, :integer
  end
end
