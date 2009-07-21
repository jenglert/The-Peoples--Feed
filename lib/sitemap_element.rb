class SitemapElement
  
  attr_accessor :url, :created_at
  
  def initialize (url, created_at)
    @created_at = created_at
    @url = url
  end
  
end