require 'test_helper'

class FeedThreeTest < ActiveSupport::TestCase

  def setup
    @feed = Feed.find(3)
  end
  
  def teardown
    @feed = nil
  end

  def test_normal_updating
    assert_equal 0, @feed.feed_items.length

    @feed.update_feed
    @feed = Feed.find(3) # Ensure that we can retrieve the proper feed from the database

    assert_equal 22, FeedItem.find_all_by_feed_id(3).length
    assert_equal 22, @feed.feed_items.length
    assert_equal "", @feed.description
#   This doesn't work yet.
#   assert_equal 'http://graphics.nytimes.com/images/section/NytSectionHeader.gif', @feed.imageUrl
    assert_equal 'NYT > Small Business', @feed.title
    assert_equal 'http://www.nytimes.com/pages/business/smallbusiness/index.html?partner=rss', @feed.url
    
    # check each feed item.
    @feed.feed_items.each { |feed_item|
      assert_not_nil feed_item.title
      assert_not_nil feed_item.item_url
      assert_not_nil feed_item.guid
      assert_not_nil feed_item.pub_date
    }
    
    first_feed_item = @feed.feed_items[0]
    
    assert_equal 9, first_feed_item.feed_item_categories.length
    assert_equal 'From High-Finance Pinnacles to Unemployment Line to Mentors', first_feed_item.title
    assert_equal 'http://feeds.nytimes.com/click.phdo?i=dda06e9c24f31250bac78a449b809c40', first_feed_item.item_url
    assert_equal 'Unemployment', first_feed_item.categories[0].name
    
  end
  
  def test_update_twice
    assert_equal 0, @feed.feed_items.length
    
    @feed.update_feed
    assert_equal 22, @feed.feed_items.length
    
    @feed.update_feed
    assert_equal 22, @feed.feed_items.length
  end

end
