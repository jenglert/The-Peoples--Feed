class AlterFeedItemAddCommentCount < ActiveRecord::Migration
  def self.up
        add_column :feed_items, :comments_count, :integer, :default => 0
  end

  def self.down
  end
end
