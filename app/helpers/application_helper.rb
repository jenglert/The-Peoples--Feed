
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # Sets the title of this page.
  def page_title(name, options = {})
    @page_title = name
    content_tag("H1", name) if options[:write] != false
  end
  
  # Adds a meta description to the page.
  def meta_description(description)
    @meta_description = description
    return ""
  end
  
  def show_ads()
    if current_user 
      preferences = UserPreference.find_by_user_id(current_user.id)
      return preferences.show_ads unless preferences.nil?
    end
    
    true 
  end
  
end
