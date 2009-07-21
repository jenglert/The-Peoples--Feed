class SitemapController < ApplicationController

  layout 'blank'
  
  caches_page :index

  # Renders the sitemap.xml URL
  def index
    @items = []
  
    # Random pages
    @items.push SitemapElement.new('/', DateTime.now)
    @items.push SitemapElement.new('/sitemap', DateTime.now);
  
    for feed in Feed.find(:all, :select => "id, created_at")
      @items.push SitemapElement.new(url_for(feed), feed.created_at)
    end
  
    for feed_item in FeedItem.find(:all, :select => "id, created_at", :limit => 1000, :order => 'created_at desc')
      @items.push SitemapElement.new(url_for(feed_item), feed_item.created_at)
    end

    response.content_type = "text/xml"
  end

end
