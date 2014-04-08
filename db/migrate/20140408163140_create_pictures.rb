class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :avatar
      t.string :avatar_caption
      t.string :banner
      t.string :banner_caption
      t.string :picturable_type
      t.integer :picturable_id

      t.timestamps
    end
  end
end
