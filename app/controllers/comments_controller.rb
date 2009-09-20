class CommentsController < ApplicationController
  
  def index
    @comments = Comment.paginate(:all, :per_page => 40,  :page => params[:page])
  end
  
  # Removes a comment.  This is specificially not the 'delete' method that is provided with rails. I don't want to have to deal
  # with the delete syntax that comes with rails.
  def remove
    @id = params[:id]
    Comment.find_by_id(@id).destroy
    
    respond_to do |format|
      format.html { redirect_to :controller => 'comments' }
      format.js 
    end
  end
  
end