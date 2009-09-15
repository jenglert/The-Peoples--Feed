class CommentsController < ApplicationController
  
  def index
    @comments = Comment.paginate(:all, :per_page => 20,  :page => params[:page])
  end
  
  def destroy
    id = params[:id]
    Comment.find_by_id(id).destroy
    
    redirect_to :controller => 'comments'
  end
  
end