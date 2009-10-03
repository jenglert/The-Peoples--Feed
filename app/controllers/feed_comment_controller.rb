class FeedCommentController < ApplicationController

  before_filter :login_required

  def create
    comment = Comment.new(params[:comment])
    feed = Feed.find(params[:commented_item_id])
    
    feed.comments << comment
    
    if !feed.save
      
    end
    
    redirect_to feed
  end
end