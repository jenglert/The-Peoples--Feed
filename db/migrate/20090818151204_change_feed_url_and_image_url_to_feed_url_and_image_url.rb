class ChangeFeedUrlAndImageUrlToFeedUrlAndImageUrl < ActiveRecord::Migration
  def self.up
    rename_column :feeds, :imageUrl, :image_url
    rename_column :feeds, :feedUrl, :feed_url
  end

  def self.down
    rename_column :feeds, :image_url, :imageUrl
    rename_column :feeds, :feed_url, :feedUrl
  end
end
