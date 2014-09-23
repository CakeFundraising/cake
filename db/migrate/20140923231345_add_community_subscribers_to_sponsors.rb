class AddCommunitySubscribersToSponsors < ActiveRecord::Migration
  def change
    add_column :sponsors, :email_subscribers, :string
    add_column :sponsors, :facebook_subscribers, :string
    add_column :sponsors, :twitter_subscribers, :string
    add_column :sponsors, :pinterest_subscribers, :string
  end
end
