class FeedController < ApplicationController
  
  before_filter :admin_authorized?, :only => [:remove_feed]
  
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
  
  def remove_feed
    feed = Feed.find(params[:id])
    
    if feed.destroy
      flash[:notice] = "The feed has been sucessfully deleted."
    else
      flash[:error] = "Unable to delete feed"
    end
    
    redirect_to :controller => 'feed', :action => 'index'
  end
  
  def admin
    @feeds = Feed.find(:all)
    render :layout => 'search'
  end
  
end
