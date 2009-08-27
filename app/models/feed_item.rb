require 'acts_as_commentable'
ActiveRecord::Base.send(:include, Juixe::Acts::Commentable)

class FeedItem < ActiveRecord::Base
  
  belongs_to :feed
  has_many :feed_item_categories
  has_many :categories, :through => :feed_item_categories
  acts_as_commentable
  
  before_save :update_rating

  named_scope :recent, :conditions => ["created_at > ?", 3.days.ago]
  named_scope :for_feed, lambda { |*args| {:conditions => ["feed_id = ?", args.first]}}
  
  def FeedItem.find_top_feed_items
    FeedItem.find(:all, :limit => 20, :order => 'rating desc')
  end

  # The guid will be either the defined guid (preferrably) or the entry's link
  def set_guid_from_entry(entry)
    if !entry.id.nil?
      self.guid = entry.id.strip
    elsif !entry.url.nil?
      self.guid = entry.url.strip
    elsif !entry.title.nil?
      self.guid = entry.title
    end
  end
  
  def set_image_url_from_entry(entry)
    self.image_url = entry.media_content[0].url if entry.media_content \
    and entry.media_content.length > 0
  end
  
  def FeedItem.initialize_from_entry(entry)
    new_feed_item = FeedItem.new(
      :title => entry.title.strip.remove_html,
      :item_url => entry.url.strip,
      :description => entry.summary.strip.remove_html,
      :pub_date => Time.parse("#{entry.published}")
    )   
    new_feed_item.set_image_url_from_entry(entry)
    new_feed_item.set_guid_from_entry(entry)
    new_feed_item.update_categories(entry.categories)
    new_feed_item
  end
  
  def update_categories(categories)
    temp = []
    categories.each do |rss_category|
      rss_category.strip.split(',').each do |rss_category_split|
        # Create the new category is necessary
        category_name = rss_category_split.strip
        unless temp.include? category_name
          temp << category_name
          category = Category.find_by_name(category_name)
          unless category  
            # Try to find a merge category before creating a new category.x
            category_merge = CategoryMerge.find_by_merge_src(category_name)
            if category_merge
              category = Category.find_by_id(category_merge.merge_target)
            end 
          end
          if !category
            category = Category.new :name => category_name
          end
          self.categories << category
        end
      end
    end
    
  rescue => ex
    LOG.error "Failed to update categories: #{ex.message}: #{ex.backtrace}"
  end
  
  def update_rating
    new_rating = calculate_rating
    self.update_attributes :rating => new_rating if new_rating != self.rating
  end
  
  # The overall rating for this feed item.
  def calculate_rating
    time_multiplier * (clicks_points + description_points + comments_points + image_points + category_points).to_f
  end
  
  def time_multiplier
    # Calculates a multiplier from 0 to 1 which serves to indicate how new the feed is.
    time = self.created_at || Time.now
    time_multiplier = (time - 3.days.ago)/3.days
    return 0 if time_multiplier < 0.05 
    time_multiplier
  end
  
  def clicks_points
    # Ensure that the number of clicks is always at least 0
    self.clicks = 0 if self.clicks.nil?
    clicks
  end
  
  def image_points
    image_url ? 4 : 0
  end
  
  def description_points
    return 0 if description.nil?
    points = self.description.length / 100
    points = 2 if points > 2
    points
  end
  
  def comments_points
    self.comments_count * 5
  end
  
  def category_points
    self.feed_item_categories_count > 3 ? 3 : self.feed_item_categories_count
  end
end
