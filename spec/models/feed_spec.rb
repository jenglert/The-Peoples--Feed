require File.dirname(__FILE__) + '/../spec_helper'

describe FeedItem do
  
  before(:all) do
    FeedParseLog.destroy_all
  end

  it "should set rating to 0 if new record" do
    @feed = Feed.new
    @feed.rating.should == 0
  end

  it "should set rating to 0 if new record" do
    @feed_item1 = FeedItem.create! :image_url => 'http://localhost'
    @feed_item2 = FeedItem.create! :image_url => 'http://localhost'
    @feed = Feed.create!(
      :feed_url => 'http://localhost',
      :feed_items => [@feed_item1, @feed_item2]
    )
    @feed.rating.should be_close(@feed_item1.rating.to_f + @feed_item2.rating.to_f, 0.1)
  end
  
  it "should update feed using feed_url" do
    @feed = Feed.new :feed_url => 'http://localhost'
    @entry1 = mock(Feedzirra::Parser::RSSEntry, 
      :title => 'Title',
      :url => 'http://localhost',
      :summary => 'Summary',
      :published => Time.now,
      :media_content => nil,
      :id => 'http://localhost',
      :categories => ["category1", "category2"]
    )
    @entry2 = mock(Feedzirra::Parser::RSSEntry, 
      :title => 'Title',
      :url => 'http://localhost?p=22',
      :summary => 'Summary',
      :published => Time.now,
      :media_content => nil,
      :id => 'http://localhost?p=22',
      :categories => ["category1"]
    )
    @entries = [@entry1, @entry2]
    @parser = mock(Feedzirra::Parser::RSS,
      :title => 'Title',
      :entries => @entries,
      :description => "",
      :url => 'http://localhost',
      :image => nil
    )
    Feedzirra::Feed.should_receive(:fetch_and_parse).and_return(@parser)
    @feed.update_feed
    @feed.feed_items.size.should == 2
    @feed.feed_items[0].categories.size.should == 2
    @feed.feed_items[1].categories.size.should == 1
    FeedParseLog.count.should == 1
    Category.count.should == 2
  end
  
  it "should not save if the feed URL is blank" do
    feed = Feed.new
    feed.save.should be_false
    
    feed.errors.entries[0][0].should == 'feed_url'
    feed.errors.entries[0][1].should == "can't be blank"
  end

  it "should not save without any feed items" do
    feed = Feed.new(:feed_url => 'thisdoesnotexist')
    feed.save.should be_false
    
    feed.errors.entries.length.should == 1
    
    # We should be able to save the feed item after we have added a feed item.
    feed.feed_items << FeedItem.new
    feed.save.should be_true
  end
end
