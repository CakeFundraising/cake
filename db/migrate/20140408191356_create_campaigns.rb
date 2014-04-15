class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :title
      t.datetime :launch_date
      t.datetime :end_date
      t.string :cause
      t.string :scope
      t.string :headline
      t.text :story
      t.boolean :no_sponsor_categories, default: false
      t.string :status, default: :private
      t.integer :fundraiser_id

      t.timestamps
    end
  end
end
