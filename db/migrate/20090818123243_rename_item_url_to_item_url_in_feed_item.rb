class RenameItemUrlToItemUrlInFeedItem < ActiveRecord::Migration
  def self.up
    rename_column :feed_items, :itemUrl, :item_url
  end

  def self.down
    rename_column :feed_items, :item_url, :itemUrl
  end
end
