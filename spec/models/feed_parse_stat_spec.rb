require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FeedParseStat do
  
  before(:all) do
    FeedParseLog.create!(:feed_id => 1, :feed_items_added => 5, :parse_start => Time.now, :parse_finish => Time.now)
                           
    FeedParseLog.create!(:feed_id => 1, :feed_items_added => 3, :parse_start => Time.now, :parse_finish => Time.now)                          
                        
    FeedParseLog.create!(:feed_id => 1, :feed_items_added => 3, :parse_start => Time.now - 3.days, :parse_finish => Time.now - 3.days)
                          
    FeedParseLog.create!(:feed_id => 2, :feed_items_added => 9, :parse_start => Time.now, :parse_finish => Time.now)
                           
    FeedParseStat.refresh
  end
  
  it "should have a day of year equal to today" do
    FeedParseStat.find_by_feed_id(1).parse_day.should == Time.now.to_date
  end
  
  it "should have aggregrated the number of feed items added across multiple logs" do
    FeedParseStat.find_by_feed_id(1).feed_items_added.should == 8
  end
  
  it "should have aggregrated the second feed" do
    FeedParseStat.find_by_feed_id(2).feed_items_added.should == 9
  end
  
  it "should be able to refresh the stats for a particular day" do
    FeedParseStat.find_by_feed_id(2).feed_items_added.should == 9
    
    FeedParseLog.create!(:feed_id => 2, :feed_items_added => 3, :parse_start => Time.now, :parse_finish => Time.now)
    
    FeedParseStat.refresh
    
    FeedParseStat.find_by_feed_id(2).feed_items_added.should == 12
  end
end
