class MakeGuidUnique < ActiveRecord::Migration
  def self.up
    FeedItem.all.each do |fi|
      FeedItem.find_all_by_guid(fi.guid).each do |found_feed_item| 
        if found_feed_item.id != fi.id
          found_feed_item.destroy
        end
      end
    end
    
    execute "create unique index feed_item_guid_uidx on feed_items(guid)"
  end

  def self.down
  end
end
