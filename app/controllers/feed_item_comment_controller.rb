class FeedItemCommentController < ApplicationController

  def create
    comment = Comment.new(params[:comment])
    feed_item = FeedItem.find(params[:commented_item_id])
    
    # Be sure to also increment the comment count.
    feed_item.comments_count = feed_item.comments_count + 1
    feed_item.comments << comment
    
    if !feed_item.save
      flash[:error] = "Unable to save comment. Please try again."
    end
    
    redirect_to feed_item
  end
end