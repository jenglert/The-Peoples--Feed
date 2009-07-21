class FeedController < ApplicationController
  
  def index
    @feeds = Feed.find(:all)
  end
  
  def new
    @feed = Feed.new
  end
  
  def create
    @feed = Feed.new(params[:feed])
    puts @feed.url
    @feed.update_feed
    
    if @feed.save
      
      flash[:notice] = "Feed was successfully created."
      redirect_to(@feed)
    else
      render :action => "new"
    end
  end
  
  def show 
    @feed = Feed.find(params[:id])
    @feed_items = FeedItem.paginate(:page => params[:page], :per_page => 15, 
            :conditions => ['feed_id = ?', params[:id]], :order => 'created_at desc')
  end
  
  def update
    @feeds = Feed.find(:all)
    @feeds.each { |feed| feed.update_feed }
  end
  
end
