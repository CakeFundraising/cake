class AddStatusToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :status, :string, default: :charged
  end
end
