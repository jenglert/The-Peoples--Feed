class AlterFeedAddClicks < ActiveRecord::Migration
  def self.up
        add_column :feeds, :clicks, :integer, :default => 0
        change_column :feed_items, :clicks, :integer, :default => 0
  end

  def self.down
  end
end
