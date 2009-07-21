class AlterFeedItemAddImage < ActiveRecord::Migration
  def self.up
    add_column :feed_items, :image_thumbnail, :string, :limit => 255
    add_column :feed_items, :image_url, :string, :limit => 255
    add_column :feed_items, :image_credits, :string, :limit => 255
  end

  def self.down

  end
end
