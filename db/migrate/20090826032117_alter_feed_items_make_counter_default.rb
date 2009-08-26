class AlterFeedItemsMakeCounterDefault < ActiveRecord::Migration
  def self.up
    change_column :feed_items, :feed_item_categories_count, :integer, :default => 0

    FeedItem.find(:all, :conditions => "feed_item_categories_count is null").each { |feed_item| feed_item.update_attributes!(:feed_item_categories_count => 1)}
  end

  def self.down
  end
end
