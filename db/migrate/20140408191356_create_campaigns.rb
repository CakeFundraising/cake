class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :title
      t.datetime :launch_date
      t.datetime :end_date
      t.string :cause
      t.string :headline
      t.text :story
      t.string :show_donation, default: :no_donations
      t.string :status, default: :private
      t.integer :fundraiser_id

      t.timestamps
    end
  end
end
