require 'test_helper'

class FeedOneTest < ActiveSupport::TestCase
  def test_save_blank_feed_throws_errors
      feed = Feed.new
      assert !feed.save
      
      assert_equal 2, feed.errors.entries.length
      
      assert_equal 'feed_url', feed.errors.entries[0][0]
      assert_equal "can't be blank", feed.errors.entries[0][1]      
      
      feed.feed_url = 'jim'
      
      assert !feed.save
      
      assert_equal 1, feed.errors.entries.length
  end
  
  def test_save_feed_without_items_throws_error
    feed = Feed.new
    feed.feed_url = 'jim'
    
    feed.save
    
    assert_equal 1, feed.errors.entries.length
    
    # Add the next feed item and save the feed to prompt any errors
    feed.feed_items << FeedItem.new
    feed.save
    
    assert_equal 0, feed.errors.entries.length
  end
end
