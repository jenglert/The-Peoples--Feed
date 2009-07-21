module Feedzirra
  module Parser
    class RSSEntry
      class MRSSCredit
        include SAXMachine

        element :'media:credit', :as => :role, :value => :role
        element :'media:credit', :as => :scheme, :value => :scheme
        element :'media:credit', :as => :name
      end
    end
  end
end
