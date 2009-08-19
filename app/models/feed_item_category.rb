class FeedItemCategory < ActiveRecord::Base
  belongs_to :feed_item, :counter_cache => true
  belongs_to :category, :counter_cache => true
  
  validates_presence_of :feed_item_id
  validates_presence_of :category_id
end
