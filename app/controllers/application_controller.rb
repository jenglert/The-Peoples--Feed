# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  helper :all # include all helpers, all the time
  helper_method :admin_logged_in?
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  before_filter :load_nav_data
  
  layout 'standard'
  
  caches_action :load_nav_data
  
  # Determines whether an administrator is logged in.
  def admin_logged_in? 
    logged_in? && current_user.admin
  end
  
  # Filter that will ensure that the admin is logged in
  def admin_authorized?
    redirect_to '/' if !admin_logged_in?
  end
  
  def rescue_404
    rescue_action_in_public(ActionController::RoutingError)
  end
  
  # In case of an error, we show this exception.
  def rescue_action_in_public(exception)
    render :template => "shared/error500", :layout => "standard", :status => "500"         
  end

  def local_request?
    return false
  end
  
  def load_nav_data
    unless read_fragment({:controller => 'homepage', :action => 'homepage', :left_navigation => 'top_feeds'})
      @topFeeds = Feed.top_feeds
    end
    
    unless read_fragment({:controller => 'homepage', :action => 'homepage', :left_navigation => 'top_categories'})
      @topCategories = Category.find(:all, :order => "feed_item_categories_count desc", :limit => 8)
    end
    
    unless read_fragment({:controller => 'homepage', :action => 'homepage', :left_navigation => 'top_media'})
      @topMedia = FeedItem.find(:all, :conditions => "image_url is not null", :limit => 8, :order => "updated_at desc")
    end
  end
  
  def update_all_feeds() 
    feeds = Feed.find(:all)
    updated_feeds = []
    
    for feed in feeds
      if feed.updated_at < Time.now.ago(45.minutes)
        feed.update_feed()
        
        updated_feeds << feed
      end
    end
    
    return updated_feeds
  end
  
  # Determines if the page is available.
  def page_available(url)
    if !url.match(/^http/i)
      url = 'http://' + url
    end
    
    open(url) { |f|     
      if f.base_uri.host.match(/search.domainnotfound.optimum.net/)
        return false
      end
      return true
    }
    
    return false
  rescue
    return false  
  end
  
  def remove_html(str)
    return str.gsub(/<\/?[^>]*>/, "")
  end

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
