class AddCommunitySubscribersToFundraisers < ActiveRecord::Migration
  def change
    add_column :fundraisers, :email_subscribers, :string
    add_column :fundraisers, :facebook_subscribers, :string
    add_column :fundraisers, :twitter_subscribers, :string
    add_column :fundraisers, :pinterest_subscribers, :string
  end
end
