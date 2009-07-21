class CategoryOrganizerController < ApplicationController
  
  def index 
    @categories_alphabetically = Category.find(:all, :order => 'name asc')
  end
  
  # Display a list of all the categories except the one that is being merged.
  def merge
    @category_to_merge = Category.find(params[:id])
    @other_categories = Category.find(:all, :order => 'name asc')
    @other_categories.delete(@category_to_merge)
  end
  
  # Submit the category merge.
  def submit_merge
    categories_to_merge = params[:categories]
    
    merge_src = Category.find(params[:original_category_id])
    
    for category_to_merge in categories_to_merge
      next if category_to_merge[1] == "0"
      
      mergeCat = CategoryMerge.new
      mergeCat.merge_src = merge_src.name
      mergeCat.merge_target = category_to_merge.object_id  
      mergeCat.save
      
      # Delete all the feed item categories that existing on other items
      feed_item_categories = FeedItemCategory.find_all_by_category_id(params[:original_category_id])
      for feed_item_category in feed_item_categories      
        new_feed_item_category = FeedItemCategory.new
        new_feed_item_category.feed_item_id = feed_item_category.feed_item_id
        new_feed_item_category.category_id = category_to_merge[0]
        
        new_feed_item_category.save
        
        feed_item_category.delete
      end
    end
    
    merge_src.delete
    redirect_to '/category_organizer'
  end
  
  # Deletes a category
  def delete
    category = Category.find(params[:id])
    
    for feed_item_category in FeedItemCategory.find_all_by_category_id(category.id)
      feed_item_category.delete
    end
    
    category.delete
    
    redirect_to :controller => 'category_organizer', :action => 'index'
  end
end