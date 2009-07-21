class AlterFeedItemCreateIndex < ActiveRecord::Migration
  def self.up
    add_index :feed_items, :feed_id
  end

  def self.down

  end
end
