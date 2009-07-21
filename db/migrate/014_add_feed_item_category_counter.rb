class AddFeedItemCategoryCounter < ActiveRecord::Migration
  def self.up
    add_column :categories, :feed_item_categories_count, :integer, :default => 0

    Category.reset_column_information
    Category.find(:all).each do |c|
      Category.update_counters c.id, :feed_item_categories_count => c.feed_items.length
    end
  end

  def self.down
    remove_column :categories, :feed_item_categories_count
  end
end
