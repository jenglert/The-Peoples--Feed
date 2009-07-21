module Feedzirra
  module Parser
    class RSS
      class ITunesCategory
        include SAXMachine

        element :'itunes:category', :as => :name, :value => :text
        elements :'itunes:category', :as => :sub_categories, :value => :text
      end
    end
  end
end
