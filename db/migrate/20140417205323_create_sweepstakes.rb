class CreateSweepstakes < ActiveRecord::Migration
  def change
    create_table :sweepstakes do |t|
      t.string :title
      t.integer :winners_quantity
      t.text :claim_prize_instructions
      t.text :description
      t.text :terms_conditions
      t.string :avatar
      t.integer :pledge_id

      t.timestamps
    end
  end
end
