class CategoryController < ApplicationController
  
  def index
    @categories = Category.paginate(:page => params[:page], :per_page => 15, :order => "name asc")
  end
  
  def show
    @category = Category.find(params[:id])
    @feed_items = FeedItem.paginate(:all, :include => [:categories, :feed], :per_page => 20, :page => params[:page],
                              :conditions => "categories.id = " + @category.id.to_s, :order => "feed_items.created_at desc")
  end
  
  def edit
    @category = Category.find(params[:id])
  end
  
  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:flower])
      flash[:notice] = "Category successfully updated."
      redirect_to(@category)
    else
      render :action => "edit"
    end
  end
  
end