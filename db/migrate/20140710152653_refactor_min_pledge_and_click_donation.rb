class RefactorMinPledgeAndClickDonation < ActiveRecord::Migration
  def change
    remove_column :fundraisers, :min_pledge, :integer
    remove_column :fundraisers, :min_click_donation, :integer

    add_monetize :fundraisers, :min_pledge
    add_monetize :fundraisers, :min_click_donation
  end
end
