require 'rss/2.0'
require 'open-uri'
require 'acts_as_commentable'
ActiveRecord::Base.send(:include, Juixe::Acts::Commentable)

class Feed < ActiveRecord::Base
  has_many :feed_items
  
  acts_as_commentable
  
  validates_presence_of :feed_url
  validates_uniqueness_of :feed_url
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
    feed_parse_log = FeedParseLog.new(  
      :feed_id => self.id,
      :feed_url => self.feed_url,
      :parse_start => Time.now,
      :feed_items_added => 0
    )
    result = Feedzirra::Feed.fetch_and_parse(feed_url) 
    initialize_from_result(result, feed_parse_log)
  end
  
  def feed_items_sorted
    feed_items.find(:all, :order => 'pub_date DESC')
  end
  
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
  
  def initialize_from_result(result, feed_parse_log)
    return false unless result.title
    self.title = result.title.strip
    self.description = result.description.nil? ? "" : result.description.strip.remove_html
    self.url = result.url.strip if result.url    
    # Bug: Fix image url parsing
    self.image_url = result.image.url.strip if result.image && result.image.url 
    add_entries(result.entries, feed_parse_log)
    feed_parse_log.parse_finish = Time.new
    feed_parse_log.save
    return self.save!
  end
  
end
