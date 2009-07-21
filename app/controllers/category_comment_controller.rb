class CategoryCommentController < ApplicationController

  def create
    comment = Comment.new(params[:comment])
    category = Category.find(params[:commented_item_id])
    
    category.comments << comment
    
    if !category.save
      render :template => 'category/show'
    end
    
    redirect_to category
  end
end