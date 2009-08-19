class AddFeedItemCategoriesCountToFeedItem < ActiveRecord::Migration
  def self.up
    add_column :feed_items, :feed_item_categories_count, :integer
  end

  def self.down
    remove_column :feed_items, :feed_item_categories_count
  end
end
