
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
  
end
