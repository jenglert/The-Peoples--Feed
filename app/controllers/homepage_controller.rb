class HomepageController < ApplicationController
  
  def index
    @allFeeds = FeedItem.find_top_feed_items()
  end
  
end