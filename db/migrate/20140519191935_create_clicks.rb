class CreateClicks < ActiveRecord::Migration
  def change
    create_table :clicks do |t|
      t.string :request_ip
      t.string :email
      t.integer :pledge_id

      t.timestamps
    end

    add_index :clicks, :request_ip
  end
end
