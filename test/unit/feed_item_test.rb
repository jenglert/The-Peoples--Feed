require 'test_helper'

class FeedItemTest < ActiveSupport::TestCase
  
  def test_rating
    feed_item = FeedItem.find(1)
    feed_item.save! # Force the feed item to recalculate the rating
    
    assert_in_delta 150, feed_item.rating, 2
  end
  
  def test_rating_with_comments
    feed_item = FeedItem.find(1)
    
    feed_item.comments_count = 1
    
    feed_item.save! # Force the feed item to recalculate the rating 
    
    assert_in_delta 155, feed_item.rating, 2
  end
  
  def test_rating_with_old_article    
    feed_item = FeedItem.find(2)
    feed_item.save! # Force the feed item to recalculate the rating
    
    assert_in_delta 0, feed_item.rating, 0.00
  end
  
  def test_rating_with_half_old_article
    feed_item = FeedItem.find(3)
    feed_item.save! # Force the feed item to recalculate the rating
    
    assert_in_delta 50, feed_item.rating, 1
  end
  
  def test_rating_with_full_old_article
    feed_item = FeedItem.find(3)
    
    feed_item.created_at = Time.now.ago(20.days)
    feed_item.save! # Force the feed item to recalculate the rating
  
    assert_in_delta 0, feed_item.rating, 0.1
  end
  
  def test_description_length_points
    feed_item = FeedItem.find(4)
    feed_item.save! # Force the feed item to recalculate the rating
    
    assert_in_delta 1, feed_item.rating, 0.1
  end
end
