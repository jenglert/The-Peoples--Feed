require 'acts_as_commentable'
  ActiveRecord::Base.send(:include, Juixe::Acts::Commentable)

class BlogPost < ActiveRecord::Base
  validates_presence_of :author, :message => 'Please specify an author.'
  validates_presence_of :title, :message => 'Please specify a title.'
  validates_presence_of :post, :message => 'Actually make a post please'
  
  acts_as_commentable
  
  # This method provides a more SEO friendly URL.
  def to_param
    "#{id}-#{title.gsub(/[^a-z0-9]+/i, '-')}"
  end
end