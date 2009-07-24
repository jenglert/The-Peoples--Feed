require 'cgi'

# Add a strip HTML function to the String class.
String.class_eval {
  define_method :remove_html do
    self.gsub(/<\/?[^>]*>/, "")
  end
}

# Add a function to capitalise each word in a sentence
String.class_eval {
  define_method :capitalize_each_word do
    self.split.each { |word| word.capitalize! }.join(" ") 
  end
}

# Add a function that selectively interprets escaped characters.
String.class_eval {
  define_method :fix_html do
     fixed = CGI.unescapeHTML(self)
     return fixed
  end
}

# Returns the pretty version of the date
Time.class_eval {
  define_method :pretty do
    if (self.getlocal.today?)
      return self.getlocal.strftime("%I:%M %p")
    else
      return self.getlocal.strftime("%B %d, %Y")
    end
  end
}
