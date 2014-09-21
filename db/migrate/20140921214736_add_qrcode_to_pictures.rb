class AddQrcodeToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :qrcode, :string
    add_column :pictures, :qrcode_crop_x, :integer
    add_column :pictures, :qrcode_crop_y, :integer
    add_column :pictures, :qrcode_crop_w, :integer
    add_column :pictures, :qrcode_crop_h, :integer
  end
end
