class RemoveWebsiteUrlFromFrSponsors < ActiveRecord::Migration
  def change
    remove_column :fr_sponsors, :website_url, :string
  end
end
