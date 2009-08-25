require 'test_helper'

class FeedTwoTest < ActiveSupport::TestCase

  def setup
    @feed = Feed.find(2)
  end
  
  def teardown
    @feed = nil
  end

  def test_normal_updating
    assert_equal 0, @feed.feed_items.length

    @feed.update_feed
    @feed = Feed.find(2) # Ensure that we can retrieve the proper feed from the database

    assert_equal 8, FeedItem.find_all_by_feed_id(2).length
    assert_equal 8, @feed.feed_items.length
    assert_equal "All of QualityHealth's original articles and news stories, updated to your RSS reader or to your website every day", @feed.description
#   This needs to be fixed.
#   assert_equal 'http://www.qualityhealth.com/resources/qh2/widgets/images/qhlogo.jpg', @feed.image_url
    assert_equal 'All content from QualityHealth, updated daily', @feed.title
    assert_equal 'http://www.qualityhealth.com/', @feed.url
    
    # check each feed item.
    @feed.feed_items.each { |feed_item|
      assert_not_nil feed_item.title
      assert_not_nil feed_item.item_url
      assert_not_nil feed_item.guid
      assert_not_nil feed_item.pub_date
      assert feed_item.feed_item_categories.length > 0
      
    }
    
    categories_for_first_item = @feed.feed_items[0].categories
    
    assert_equal 1, categories_for_first_item.length
    assert_equal 'heartburn', categories_for_first_item[0].name
    
    categories_for_last_item = @feed.feed_items[7].categories.collect { |category| category.name}.sort!
    
    expected_categories = ['gerd', 'general health lifestyle', 'ibs', 'heartburn', 'fitness', 'exercise', 'diet', 'nutrition']
    expected_categories.sort!
    
    assert expected_categories.eql?(categories_for_last_item)
  end
  
  def test_update_twice
    assert_equal 0, @feed.feed_items.length
    
    @feed.update_feed
    assert_equal 8, @feed.feed_items.length
    
    @feed.update_feed
    assert_equal 8, @feed.feed_items.length
  end

end
