class AddRatingToFeeds < ActiveRecord::Migration
  def self.up
    add_column :feeds, :rating, :decimal, :precision => 8, :scale => 2
  end

  def self.down
    remove_column :feeds, :rating
  end
end
