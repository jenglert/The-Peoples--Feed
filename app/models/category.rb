require 'acts_as_commentable'
ActiveRecord::Base.send(:include, Juixe::Acts::Commentable)

class Category < ActiveRecord::Base
  has_many :feed_item_categories, :dependent => :destroy
  has_many :feed_items, :through => :feed_item_categories
  has_many :user_preferences
  
  validates_presence_of :name
  
  acts_as_commentable
end