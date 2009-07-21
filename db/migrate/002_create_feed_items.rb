class CreateFeedItems < ActiveRecord::Migration
  def self.up
    create_table :feed_items do |t|
      t.string :title
      t.string :feedItemUrl
      t.string :description
      t.string :itemUrl
      t.string :guid

      t.timestamps
    end
  end

  def self.down
    drop_table :feed_items
  end
end
