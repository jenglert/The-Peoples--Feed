class MakeGuidUnique < ActiveRecord::Migration
  def self.up
    
    execute "create index feed_item_guid_idx on feed_items(guid)"
    
    FeedItem.all.each do |fi|
      puts fi.id if fi.id % 1000 == 0
      FeedItem.find_all_by_guid(fi.guid).each do |found_feed_item| 
        if found_feed_item.id != fi.id
          found_feed_item.destroy
        end
      end
    end
    execute "drop index feed_item_guid_idx on feed_items"
    execute "create unique index feed_item_guid_uidx on feed_items(guid)"
  end

  def self.down
  end
end
