require 'test_helper'

class FeedOneTest < ActiveSupport::TestCase

  def setup
    @feed = Feed.find(1)
  end
  
  def teardown
    @feed = nil
  end

  def test_normal_updating
    assert_equal 0, @feed.feed_items.length

    @feed.update_feed
    
    assert_equal 0, @feed.errors.length 

    assert_equal 8, FeedItem.find_all_by_feed_id(1).length
    assert_equal 8, @feed.feed_items.length
    assert_equal 'QualityHealth: Latest News Stories', @feed.title
#   This doesn't work yet.
    assert_equal 'http://www.qualityhealth.com/resources/qh2/widgets/images/qhlogo.jpg', @feed.imageUrl
    assert_equal 'The latest health related news stories from QualityHealth.', @feed.description
    assert_equal 'http://www.qualityhealth.comhttp://www.qualityhealth.com/news/', @feed.url
    
    # check each feed item.
    @feed.feed_items_sorted.each { |feed_item|
      assert_not_nil feed_item.title
      assert_not_nil feed_item.itemUrl
      assert_not_nil feed_item.guid
      assert_not_nil feed_item.pub_date
      }
  end
  
  def test_update_twice
    assert_equal 0, @feed.feed_items.length
    
    @feed.update_feed
    assert_equal 8, @feed.feed_items.length
    
    @feed.update_feed
    assert_equal 8, @feed.feed_items.length
  end

end
