class AlterFeedItemDropRating < ActiveRecord::Migration
  def self.up
        remove_column :feed_items, :rating
  end

  def self.down
  end
end
