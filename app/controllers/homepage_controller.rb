class HomepageController < ApplicationController
  
  def index
    @allFeeds = FeedItem.find(:all, :limit => 100, :order => 'created_at desc', :include => "feed")
    
    @a
  end
  
end