class FeedParseLog < ActiveRecord::Base

  def increase_items
    self.feed_items_added += 1
  end
  
end
