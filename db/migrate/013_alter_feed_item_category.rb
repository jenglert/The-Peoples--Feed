class AlterFeedItemCategory < ActiveRecord::Migration
    def self.up
      add_column :feed_item_categories, :category_id, :integer
      remove_column :feed_item_categories, :name
    end

    def self.down

    end
  end
