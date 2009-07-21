class AddFeedItemClicks < ActiveRecord::Migration
  def self.up
    add_column :feed_items, :clicks, :integer
  end

  def self.down

  end
end
