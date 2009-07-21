
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # Sets the title of this page.
  def page_title(name)
    @page_title = name
    content_tag("H1", name);
  end
  
  # Adds a meta description to the page.
  def meta_description(description)
    @meta_description = description
    return ""
  end
  
end
