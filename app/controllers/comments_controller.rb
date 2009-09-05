class CommentsController < ApplicationController
  
  def index
    @comments = Comment.paginate(:all, :per_page => 20,  :page => params[:page])
  end
  
  def delete
    id = params[:id]
    Comment.find_by_id(id).remove
  end
  
end