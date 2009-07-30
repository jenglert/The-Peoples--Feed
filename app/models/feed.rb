require 'rss/2.0'
require 'open-uri'
require 'acts_as_commentable'
ActiveRecord::Base.send(:include, Juixe::Acts::Commentable)

class Feed < ActiveRecord::Base
  extend ActiveSupport::Memoizable
  has_many :feed_items
  
  acts_as_commentable
  
  validates_presence_of :feedUrl
  validates_uniqueness_of :feedUrl
  validates_presence_of :feed_items  #'Sorry, we were unable to parse the feed you provided.  Please double check the URL you have provided or email <a href=mailto:webmaster@thepeoplesfeed.com>us</a> for asisstence.'
  
  def Feed.find_top_feeds
    feeds = Feed.find(:all)
    
    feeds.sort!{ |a, b|  
      b.rating <=> a.rating
    }
    
    # We only want the top 5 feed items.
    feeds.slice!(0, 5)
  end
  
  # Determines the rating for
  def rating
    feedItemsAdder = 0
    
    feed_items = FeedItem.find(:all, :conditions => "updated_at > DATE_SUB(curdate(), INTERVAL 20 DAY) and feed_id = #{self.id}")
    
    for feed_item in feed_items
      feedItemsAdder += feed_item.rating
    end
    
    return feedItemsAdder
  end
  
  # Updates the feed
  def update_feed
    result = Feedzirra::Feed.fetch_and_parse(feedUrl)
    
    if !result.title
      return  # Possibly throw an error here
    end
    self.title = result.title.strip
    
    if result.description
      self.description = result.description.strip.remove_html
    else 
      self.description = ""
    end
    if result.url
      self.url = result.url.strip
    end
    
    # Bug: Fix image url parsing
    self.imageUrl = result.image.url.strip if result.image && result.image.url
      
    result.entries.each_with_index do |item, i|
      begin
      newFeedItem = FeedItem.new
      newFeedItem.title = item.title.strip.remove_html
      newFeedItem.itemUrl = item.url.strip
      newFeedItem.description = item.summary.strip.remove_html
      
      if item.media_content and item.media_content.length > 0
        newFeedItem.image_url = item.media_content[0].url
      end
        
      # The guid will be either the defined guid (preferrably) or the item's link
      if !item.id.nil?
        newFeedItem.guid = item.id.strip
      elsif !item.url
        newFeedItem.guid = item.url.strip
      elsif !item.title
        newFeedItem.guid = item.title
      end
        
      newFeedItem.pub_date = Time.parse("#{item.published}")
        
      if FeedItem.find_by_guid(newFeedItem.guid).nil?
        self.feed_items << newFeedItem
          
        # Only figure out the categories for items that we will be saving
        item.categories.each do |rss_category|
            
            rss_category.strip.split(',').each do |rss_category_split|
            
            if rss_category_split
              # Create the new category is necessary
              category = Category.find_by_name(rss_category_split.strip)
              if !category
                  
                # Try to find a merge category before creating a new category.x
                categoryMerge = CategoryMerge.find_by_merge_src(rss_category_split.strip)
                if categoryMerge
                  category = Category.find_by_id(categoryMerge.merge_target)
                end
                  
                if !category
                  category = Category.new
                  category.name = rss_category_split.strip
                end
              end
            
              newFeedItem.categories << category
            end
          end
        end #each_with_index
      end #if 
      rescue => ex
        logger.error "Unable to parse feed item #{self.id}. #{ex.class}: #{ex.message}"
      end
    end
    
    return self.save!
    
  rescue => ex
    logger.error "Unable to update feed: #{self.id}. #{ex.class}: #{ex.class}: #{ex.message}"
  end
  
  def feed_items_sorted
    feed_items.sort { |lhs, rhs| rhs.pub_date <=> lhs.pub_date}
  end
  
  memoize :rating
end
