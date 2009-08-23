require 'rss/2.0'
require 'open-uri'
require 'acts_as_commentable'
ActiveRecord::Base.send(:include, Juixe::Acts::Commentable)

class Feed < ActiveRecord::Base
  has_many :feed_items
  
  acts_as_commentable
  
  validates_presence_of :feed_url
  validates_uniqueness_of :feed_url
  
  named_scope :top_feeds, :order => 'rating desc', :limit => 5
  
  def validate
    if feed_items.length == 0
      errors.add_to_base 'Sorry, we were unable to parse the feed you provided.  Please double check the URL you have provided.'
    end
  end
  
  # Determines the rating for
  def rating
    return 0 if new_record?
    return 0 if self.feed_items.count.zero?    
    calculated_rating = FeedItem.find(
      :all,
      :select => 'IFNULL(sum(rating), 0) as feed_rating',
      :conditions => ["updated_at > ? and feed_id = ?", 20.days.ago, self.id],
      :group => 'feed_id')[0].feed_rating.to_d
      
    self.update_attributes :rating => calculated_rating
    calculated_rating
  end
  
  # Updates the feed
  def update_feed    
    result = Feedzirra::Feed.fetch_and_parse(feed_url) 
    save_from_result(result)
  
    # Update the ratings for all the feed items created with 20 days.
    FeedItem.find(:all, :conditions => ["updated_at > ? and feed_id = ?", 20.days.ago, self.id]).each { |feed_item| feed_item.update_rating }
    
    # Force the feed's rating to be updated
    self.rating
  end
  
  def feed_items_sorted
    feed_items.find(:all, :order => 'pub_date DESC')
  end
  
  private
  
  def add_entries(entries, feed_parse_log)
    #begin
      entries.each do |item|
        new_feed_item = FeedItem.initialize_from_entry(item)
        unless FeedItem.exists?(:guid => new_feed_item.guid)
          new_feed_item.save!
          add_feed_item(new_feed_item, feed_parse_log)        
        end        
      end #each 
    #rescue => ex
      #logger.error "Unable to parse feed item #{self.id}. #{ex.class}: #{ex.message}"
    #end
  end
  
  def add_feed_item(new_feed_item, feed_parse_log)
    self.feed_items << new_feed_item
    feed_parse_log.increase_items
  end
  
  def save_from_result(result)
    feed_parse_log = FeedParseLog.create!(  
      :feed_id => self.id,
      :feed_url => self.feed_url,
      :parse_start => Time.now,
      :feed_items_added => 0
    )
    
    return false unless result && result.title
    
    self.title = result.title.strip
    self.description = result.description.nil? ? "" : result.description.strip.remove_html
    self.url = result.url.strip if result.url    
    # Bug: Fix image url parsing
    self.image_url = result.image.url.strip if result.image && result.image.url 
    add_entries(result.entries, feed_parse_log)
    feed_parse_log.parse_finish = Time.new
    feed_parse_log.save
    return self.save
  end
  
end
