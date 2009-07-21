class AddFeedItemRating < ActiveRecord::Migration
  def self.up
    add_column :feed_items, :rating, :float
  end

  def self.down

  end
end
