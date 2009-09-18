class AddFeedItemsIndex < ActiveRecord::Migration
  def self.up
    add_index :feed_items, :rating
  end

  def self.down
  end
end
