class AddRatingToFeedItems < ActiveRecord::Migration
  def self.up
    add_column :feed_items, :rating, :decimal, :precision => 8, :scale => 2
  end

  def self.down
    remove_column :feed_items, :rating
  end
end
