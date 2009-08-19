class AddFeedItemCategoriesCountToFeedItem < ActiveRecord::Migration
  def self.up
    add_column :feed_items, :feed_item_categories_count, :integer
    
    FeedItem.reset_column_information
    
    FeedItem.find(:all).each do |f|
      FeedItem.update_counters f.id, :feed_item_categories_count => f.categories.length
    end
  end

  def self.down
    remove_column :feed_items, :feed_item_categories_count
  end
end
