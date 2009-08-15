class CreateFeedParseLogs < ActiveRecord::Migration
  def self.up
    create_table :feed_parse_logs do |t|
      t.integer :feed_id
      t.integer :feed_items_added
      t.datetime :parse_start
      t.datetime :parse_finish
      t.string :feed_url

    end
  end

  def self.down
    drop_table :feed_parse_logs
  end
end
