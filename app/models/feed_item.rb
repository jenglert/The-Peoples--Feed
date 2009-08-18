require 'acts_as_commentable'
ActiveRecord::Base.send(:include, Juixe::Acts::Commentable)

class FeedItem < ActiveRecord::Base
  
  belongs_to :feed
  has_many :feed_item_categories
  has_many :categories, :through => :feed_item_categories
  acts_as_commentable
  
  before_save :calculate_rating
  
  def FeedItem.find_top_feed_items
    FeedItem.find(:all, :limit => 20, :order => 'rating desc, created_at desc')
  end
  
  # The overall rating for this feed item.
  def calculate_rating
    self.rating = time_multiplier * (clicks_points + description_points + comments_points + image_points + category_points).to_f
  end
  
  def time_multiplier
    # Calculates a multiplier from 0 to 4 which serves to indicate how new the feed is.
    time = self.created_at || Time.now
    time_multiplier = (time - 20.days.ago)/5.days
    # Normalize the time multiplier to a maximum of 1
    time_multiplier /= 4
    return 0 if time_multiplier < 0.05 
    time_multiplier
  end
  
  private
  
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
    self.categories.count
  end
end
