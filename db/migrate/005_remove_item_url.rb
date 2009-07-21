class RemoveItemUrl < ActiveRecord::Migration
  def self.up
    remove_column :feed_items, :feedItemUrl
  end

  def self.down

  end
end
