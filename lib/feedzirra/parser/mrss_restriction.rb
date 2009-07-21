module Feedzirra
  module Parser
    class RSSEntry
      class MRSSRestriction
        include SAXMachine

        element :'media:restriction', :as => :value
        element :'media:restriction', :as => :scope, :value => :type
        element :'media:restriction', :as => :relationship, :value => :relationship
      end
    end
  end
end
