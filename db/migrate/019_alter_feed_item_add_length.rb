class AlterFeedItemAddLength < ActiveRecord::Migration
  def self.up
    change_column :feed_items, :description, :string, :limit => 4000
  end

  def self.down

  end
end
