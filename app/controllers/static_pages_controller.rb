class StaticPagesController < ApplicationController
  
    def sitemap
    end
    
    def privacy_policy
    end
    
    def contact_us
    end
    
    def advertise
    end
    
    def contribute
    end
    
    def how_it_works
    end
    
    def search
      render :layout => 'search'
    end
    
    def open_source
    end
end
