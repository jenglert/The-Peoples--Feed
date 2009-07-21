class AlterFeedItemIndexColumns < ActiveRecord::Migration
  def self.up
    add_index :feed_items, :guid
    add_index :categories, :name
  end

  def self.down

  end
end
