class AlterFeedItemAddPubDate < ActiveRecord::Migration
  def self.up
    add_column :feed_items, :pub_date, :datetime
  end

  def self.down

  end
end
