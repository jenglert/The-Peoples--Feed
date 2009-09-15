class UserPreference < ActiveRecord::Base
  belongs_to :category
  belongs_to :feed
  
  validates_presence_of :user_id
  
  # Prepares a list of category selections that the user can select as his/her category of choice.
  def user_category_selections
    categories = Category.find(:all, :order => "feed_item_categories_count desc", :limit => 20)
    categories << Category.new(:id => -1, :name => '--')
    categories << self.category unless self.category.nil?
    categories
  end
  
  # Prepares a list of feeds that the user can select as his/her favorite feed.
  def user_feed_selections
    feeds = Feed.find(:all)
    feeds << Feed.new(:id => -1, :title => '--')
    feeds
  end
end
