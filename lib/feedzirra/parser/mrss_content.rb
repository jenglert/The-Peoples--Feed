module Feedzirra
  module Parser
    class RSSEntry
      class MRSSContent
        include SAXMachine

        element :'media:content', :as => :url, :value => :url
        element :'media:content', :as => :content_type, :value => :type
        element :'media:content', :as => :medium, :value => :medium
        element :'media:content', :as => :duration, :value => :duration
      end
    end
  end
end
