class CreateFeedItemCategories < ActiveRecord::Migration
  def self.up
    create_table :feed_item_categories do |t|
      t.string :name
      t.string :feed_item_id
    end
  end

  def self.down
    drop_table :feed_item_categories
  end
end
