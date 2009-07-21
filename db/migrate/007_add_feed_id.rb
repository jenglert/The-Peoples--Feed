class AddFeedId < ActiveRecord::Migration
  def self.up
    add_column :feed_items, :feed_id, :integer
  end

  def self.down

  end
end
