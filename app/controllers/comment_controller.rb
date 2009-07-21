class CommentController < ApplicationController
  
  def index
    @comments = Comment.paginate(:all, :per_page => 20, :page => params[:page])
  end
  
end