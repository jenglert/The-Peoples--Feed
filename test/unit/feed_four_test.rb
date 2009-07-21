require 'test_helper'

class FeedThreeTest < ActiveSupport::TestCase

  def setup
    @feed = Feed.find(4)
  end
  
  def teardown
    @feed = nil
  end

  def test_normal_updating
    assert_equal 0, @feed.feed_items.length

    @feed.update_feed
    @feed = Feed.find(4) # Ensure that we can retrieve the proper feed from the database

    assert_equal 9, FeedItem.find_all_by_feed_id(4).length
    assert_equal 9, @feed.feed_items.length

    categoryCount = 0

    # check each feed item.
    @feed.feed_items.each { |feed_item|
      assert_not_nil feed_item.title
      assert_not_nil feed_item.itemUrl
      assert_not_nil feed_item.guid
      assert_not_nil feed_item.pub_date
      
      categoryCount += feed_item.categories.length
      feed_item.categories.each { |category| puts category.name }
    }
    
    assert_equal 13, categoryCount
    
    first_feed_item = @feed.feed_items.first
    assert_equal 'How the Obamas Made Washington Hot!', first_feed_item.title
    assert_equal 2, first_feed_item.categories.length    
    assert_equal 'Barack Obama', first_feed_item.categories[0].name
    assert_equal 'Michelle Obama', first_feed_item.categories[1].name
    
    last_feed_item = @feed.feed_items.last
    assert_equal 2, last_feed_item.categories.length
    assert_equal 'testernumberone', last_feed_item.categories[0].name
    
  end
  
  def test_update_twice
    assert_equal 0, @feed.feed_items.length
    
    @feed.update_feed
    assert_equal 9, @feed.feed_items.length
    
    @feed.update_feed
    assert_equal 9, @feed.feed_items.length
  end

end
