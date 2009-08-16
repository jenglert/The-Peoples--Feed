require 'net/http'
require 'acts_as_commentable'
ActiveRecord::Base.send(:include, Juixe::Acts::Commentable)

class FeedItem < ActiveRecord::Base
  extend ActiveSupport::Memoizable
  
  belongs_to :feed
  has_many :feed_item_categories
  has_many :categories, :through => :feed_item_categories
  acts_as_commentable
  
  def FeedItem.find_top_feed_items
    feedItems = FeedItem.find(:all, :limit => 100, :order => 'created_at desc')
    
    feedItems.sort! { |a, b|  
      b.rating <=> a.rating
    }
    
    # We only want the top 20 feed items.
    feedItems.slice!(0, 20)
  end
  
  # The overall rating for this feed item.
  def rating
    return time_multiplier * (clicks_points + description_points + comments_points + image_points).to_f
  end
  
  def time_multiplier
    # Calculates a multiplier from 0 to 4 which serves to indicate how new the feed is.
    time_multiplier = (self.created_at - (Time.now.ago(20.days)))/5.days
    # Normalize the time multiplier to a maximum of 1
    time_multiplier = time_multiplier / 4
    
    if time_multiplier < 0.05 
      return 0
    end
    
    return time_multiplier
  end
  
  def clicks_points
    # Ensure that the number of clicks is always at least 0
    if self.clicks.nil?
      self.clicks = 0
    end
    
    return clicks
  end
  
  def image_points
    if image_url 
      return 4
    end
    
    return 0
  end
  
  def description_points
     points = self.description.length / 100
     points = 2 if points > 2
     return points
  end
  
  def comments_points
    return self.comments_count * 5
  end
  
  def category_points
    return self.categories.length
  end
  
   memoize :rating
end
