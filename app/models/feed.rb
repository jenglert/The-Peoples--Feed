require 'rss/2.0'
require 'open-uri'
require 'acts_as_commentable'
ActiveRecord::Base.send(:include, Juixe::Acts::Commentable)

class Feed < ActiveRecord::Base
  has_many :feed_items
  
  acts_as_commentable
  
  validates_presence_of :feedUrl
  validates_uniqueness_of :feedUrl
  validates_presence_of :feed_items  #'Sorry, we were unable to parse the feed you provided.  Please double check the URL you have provided or email <a href=mailto:webmaster@thepeoplesfeed.com>us</a> for asisstence.'
  
  named_scope :top_feeds, :order => 'rating desc', :limit => 5
  
  # Determines the rating for
  def rating
    return 0 if new_record?
    return 0 if self.feed_items.count.zero?    
    calculated_rating = FeedItem.find(
      :all,
      :select => 'sum(rating) as feed_rating',
      :conditions => ["updated_at > ? and feed_id = ?", 20.days.ago, self.id],
      :group => 'feed_id')[0].feed_rating
    self.update_attributes :rating => calculated_rating
    calculated_rating
  end
  
  # Updates the feed
  def update_feed    
    feedParseLog = FeedParseLog.create!(  
      :feed_id => self.id,
      :feed_url => feedUrl,
      :parse_start => Time.now,
      :feed_items_added => 0
    )
    result = Feedzirra::Feed.fetch_and_parse(feedUrl)
    
    return unless result.title  #possibly return an error and log it
    self.title = result.title.strip
    self.description = result.description.nil? ? "" : result.description.strip.remove_html
    self.url = result.url.strip if result.url
    
    # Bug: Fix image url parsing
    self.imageUrl = result.image.url.strip if result.image && result.image.url
      
    result.entries.each_with_index do |item, i|
      begin
      new_feed_item = FeedItem.new (
        :title => item.title.strip.remove_html,
        :itemUrl => item.url.strip,
        :description => item.summary.strip.remove_html
      )
            
      new_feed_item.image_url = item.media_content[0].url if item.media_content and item.media_content.length > 0
        
      # The guid will be either the defined guid (preferrably) or the item's link
      if !item.id.nil?
        new_feed_item.guid = item.id.strip
      elsif !item.url
        new_feed_item.guid = item.url.strip
      elsif !item.title
        new_feed_item.guid = item.title
      end
        
      new_feed_item.pub_date = Time.parse("#{item.published}")
        
      if FeedItem.find_by_guid(new_feed_item.guid).nil?
        self.feed_items << new_feed_item
        feedParseLog.feed_items_added += 1
          
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
            
              new_feed_item.categories << category
            end
          end
        end #each_with_index
      end #if 
      rescue => ex
        logger.error "Unable to parse feed item #{self.id}. #{ex.class}: #{ex.message}"
      end
    end
    
    feedParseLog.parse_finish = Time.new
    feedParseLog.save
    return self.save!
    
  rescue => ex
    logger.error "Unable to update feed: #{self.id}. #{ex.class}: #{ex.class}: #{ex.message}"
  end
  
  def feed_items_sorted
    feed_items.find(:all, :order => 'pub_date DESC')
  end

end
