require 'acts_as_commentable'
ActiveRecord::Base.send(:include, Juixe::Acts::Commentable)

class Category < ActiveRecord::Base
  has_many :feed_item_categories
  has_many :feed_items, :through => :feed_item_categories
  
  acts_as_commentable
end