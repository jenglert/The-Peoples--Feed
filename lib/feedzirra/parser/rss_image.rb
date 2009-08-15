module Feedzirra
  module Parser
    class RSSImage
      include SAXMachine
      element :title
      element :link
      element :url
      element :width
      element :height
    end
  end
end
