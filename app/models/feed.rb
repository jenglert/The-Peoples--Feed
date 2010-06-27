require 'rss/2.0'
require 'open-uri'
require 'acts_as_commentable'

ActiveRecord::Base.send(:include, Juixe::Acts::Commentable)

class Feed < ActiveRecord::Base
  has_many :feed_items, :dependent => :destroy
  has_many :user_preferences
  
  belongs_to :site
  
  acts_as_commentable
  
  validates_presence_of :feed_url
  validates_uniqueness_of :feed_url
  
  named_scope :top_feeds, :order => 'rating desc', :limit => 5
  
  before_destroy :destroy_feed_parse_logs
  
  # Removes all the feed parse logs before destroying the 
  def destroy_feed_parse_logs
    FeedParseLog.find_all_by_feed_id(self.id).each { |fpl| fpl.destroy }
  end
  
  def validate
    if feed_items.length == 0
      errors.add_to_base 'Sorry, we were unable to parse the feed you provided.  Please double check the URL you have provided.'
    end
  end
  
  # Determines the rating for
  def rating
    return 0 if new_record?
    return 0 if self.feed_items.count.zero?    
    calculated_rating = 0
    
    # This query can return nil if there are no feed items that match the conditions.
    result = FeedItem.find(
      :all,
      :select => 'sum(rating) as feed_rating',
      :conditions => ["created_at > ? and feed_id = ?", 3.days.ago, self.id])[0]
      
    calculated_rating = result.feed_rating.to_d unless result.nil? or result.feed_rating.nil?
      
    self.update_attributes :rating => calculated_rating
    calculated_rating
  end
  
  # Updates the feed
  def update_feed    
    return if (self.disabled)
    
    startTime = Time.now
    
    result = Feedzirra::Feed.fetch_and_parse(feed_url, :compress => true, :timeout => 5) 
    
    save_from_result(result)
  
    # Update the ratings for all the feed items created with 3 days.
    FeedItem.recent.for_feed(self.id).each { |feed_item| feed_item.update_rating }
    
    # Force the feed's rating to be updated
    self.rating
    
    # Ensure that the operation took less than 15 seconds. If it took more, set the feed to disabled.
    if(Time.now - startTime > 15) 
      update_attribute(:disabled, true)
    end
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
          startTime = Time.now
          new_feed_item.save!
          add_feed_item(new_feed_item, feed_parse_log)        
        end        
      end #each 
    rescue => ex
      logger.error "Unable to parse feed #{self.id}. #{ex.class}: #{ex.message} : #{ex.backtrace}"
  end
  
  def add_feed_item(new_feed_item, feed_parse_log)
    self.feed_items << new_feed_item
    feed_parse_log.increase_items
  end

  # Save the result of the Feedzirra request into the database.
  def save_from_result(result)
    feed_parse_log = FeedParseLog.create!(  
      :feed_id => self.id,
      :feed_url => self.feed_url,
      :parse_start => Time.now,
      :feed_items_added => 0
    )

    # We need to check whether the result will respond to certain methods. Depending
    # on the type of feed that was parsed, all of these parameters may or may not
    # be present.
    return false unless result && result.respond_to?('title') && result.title
    

    # Ensure that the feed doesn't have too many entries. If it does, ignore the feed.
    if (result.entries.size() > 45) 
      self.update_attribute(:disabled, true)
      return
    end
    
    self.title = result.title.strip

    # The SAX machine may or may not have added description
    self.description = result.respond_to?('description') && result.description ? result.description.strip.remove_html : ""

    self.url = result.url.strip if result.url    
    # Bug: Fix image url parsing
    self.image_url = result.image.url.strip if result.respond_to?('image') && result.image && result.image.url  
    add_entries(result.entries, feed_parse_log)
    feed_parse_log.parse_finish = Time.new
    feed_parse_log.save
    return self.save
  end
  
end
