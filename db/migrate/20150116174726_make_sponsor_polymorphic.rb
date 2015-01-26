class MakeSponsorPolymorphic < ActiveRecord::Migration
  def change
    add_column :pledges, :sponsor_type, :string
  end
end
