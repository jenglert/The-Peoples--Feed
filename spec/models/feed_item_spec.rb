require File.dirname(__FILE__) + '/../spec_helper'

describe FeedItem do
  
  it "should set rating to 0 after saved with no parameters" do
    @feed_item = FeedItem.create!
    @feed_item.rating.should == 0
  end
  
  it "should calculate rating after created with parameters" do
    @feed_item = FeedItem.create!(
      :image_url => 'http://localhost'
    )
    @feed_item.rating.should_not == 0
  end
  
  it "should calculate rating after update" do
    @feed_item = FeedItem.create!
    @feed_item.rating.should == 0
    @feed_item.image_url = 'http://localhost'
    @feed_item.save!
    @feed_item.rating.should_not == 0
  end
  
  it "should set guid to id" do
    @entry = mock(Feedzirra::Parser::RSSEntry, :id => "http://localhost/?p=2245")
    @feed_item = FeedItem.new
    @feed_item.set_guid_from_entry(@entry)
    @feed_item.guid.should == "http://localhost/?p=2245"
  end
  
  it "should set guid to url" do
    @entry = mock(Feedzirra::Parser::RSSEntry, :id => nil, :url => "http://localhost/?p=2245")
    @feed_item = FeedItem.new
    @feed_item.set_guid_from_entry(@entry)
    @feed_item.guid.should == "http://localhost/?p=2245"
  end
  
  it "should set guid to title" do
    @entry = mock(Feedzirra::Parser::RSSEntry, :id => nil, :url => nil, :title => "http://localhost/?p=2245")
    @feed_item = FeedItem.new
    @feed_item.set_guid_from_entry(@entry)
    @feed_item.guid.should == "http://localhost/?p=2245"
  end
  
  it "should set image_url" do 
    @media_content = mock(Feedzirra::Parser::RSSEntry::MRSSContent,
      :url => "http://localhost/?p=2245"
    )
    @entry = mock(Feedzirra::Parser::RSSEntry,
      :media_content => [@media_content]
    )
    @feed_item = FeedItem.new
    @feed_item.set_image_url_from_entry(@entry)
    @feed_item.image_url.should == "http://localhost/?p=2245"
  end
  
  it "should not set image_url" do 
    @entry = mock(Feedzirra::Parser::RSSEntry,
      :media_content => []
    )
    @feed_item = FeedItem.new
    @feed_item.set_image_url_from_entry(@entry)
    @feed_item.image_url.should == nil
  end
  
  it "should initialize from entry" do 
    @entry = mock(Feedzirra::Parser::RSSEntry,
      :title => 'Title',
      :url => 'http://localhost',
      :summary => 'Summary',
      :published => Time.parse('Fri Aug 14 17:20:20 UTC 2009'),
      :media_content => [],
      :id => nil,
      :categories => ["Misc"]
    )
    @feed_item = FeedItem.initialize_from_entry(@entry)
    @category = Category.new :name => "Misc"
    @feed_item.title.should == 'Title'
    @feed_item.item_url.should == 'http://localhost'
    @feed_item.description.should == 'Summary'
    @feed_item.pub_date.should == Time.parse('Fri Aug 14 17:20:20 UTC 2009')
    @feed_item.guid.should == 'http://localhost'
    @feed_item.categories.length.should == 1
    @feed_item.categories[0].name.should == 'Misc'
  end
  
  it "should update categories if each item in array is one category" do
    @feed_item = FeedItem.new
    @categories = ["cat1", "cat2"]
    @feed_item.update_categories(@categories)
    @feed_item.categories.length.should == 2
  end
  
  it "should update categories if items in array do not correspond to one category" do
    @feed_item = FeedItem.new
    @categories = ["cat1, cat2", "cat3, cat4, cat5"]
    @feed_item.update_categories(@categories)
    @feed_item.categories.length.should == 5
  end
  
  it "should not update categories if they have the same name" do
    @feed_item = FeedItem.new
    @categories = ["cat1, cat1"]
    @feed_item.update_categories(@categories)
    @feed_item.categories.length.should == 1
  end

  it "should have recent feeds that return feeds from the last 3 days" do
    feeditem1 = FeedItem.create!(:created_at => 1.days.ago)
    feeditem2 = FeedItem.create!(:created_at => 2.days.ago)
    feeditem3 = FeedItem.create!(:created_at => 3.1.days.ago)
    feeditem4 = FeedItem.create!(:created_at => 4.days.ago)

    FeedItem.recent.should include(feeditem1)
    FeedItem.recent.should include(feeditem2)
    FeedItem.recent.should_not include(feeditem3)
    FeedItem.recent.should_not include(feeditem4)
  end
  
  it "should be searchable by feed id" do
    feed = Feed.create!(:feed_url => 'test', :feed_items => [FeedItem.create!()])
    feeditem1 = FeedItem.create!(:feed_id => feed.id)
    
    FeedItem.for_feed(feed.id).should include(feeditem1)
    FeedItem.for_feed(-1).should_not include(feeditem1)
  end
end
