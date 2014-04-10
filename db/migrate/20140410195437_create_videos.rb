class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :recordable_type
      t.integer :recordable_id
      t.string :url

      t.timestamps
    end
  end
end
