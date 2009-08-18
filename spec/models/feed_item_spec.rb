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
end
