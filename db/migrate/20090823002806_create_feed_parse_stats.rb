class CreateFeedParseStats < ActiveRecord::Migration
  def self.up
    create_table :feed_parse_stats do |t|
      t.integer :feed_id, :null => false
      t.date :parse_day
      t.integer :feed_items_added
    end
  end

  def self.down
    drop_table :feed_parse_stats
  end
end
