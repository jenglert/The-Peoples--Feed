require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FeedParseStat do
  
  before(:all) do
    @feed = Feed.new(:feed_url => 'test')
    @feed.feed_items << FeedItem.new()
    @feed.save!
    
    FeedParseLog.create!(:feed_id => @feed.id,
                           :feed_items_added => 5, 
                           :parse_start => Time.now, 
                           :parse_finish => Time.now)
  end
  
  it "should have a day of year equal to today" do
    "#{FeedParseStat.find_by_feed_id(@feed.id).dayofyear}".should == Time.now.strftime('%j') # day of the year
  end
  
  it "There should be 5 feeds parsed" do
    FeedParseStat.find_by_feed_id(@feed.id).feed_items_added.should == 5
  end
end
