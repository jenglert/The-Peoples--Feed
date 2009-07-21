module Feedzirra
  module Parser
    # == Summary
    # Parser for dealing with RSS feeds.
    #
    class RSS
      include SAXMachine
      include FeedUtilities

      attr_accessor :feed_url

      # RSS 2.0 required elements
      element :title
      element :link, :as => :url
      element :description
      elements :item, :as => :entries, :class => RSSEntry

      # RSS 2.0 optional elements
      element :language
      element :copyright
      element :managingEditor
      element :webMaster
      element :pubDate
      element :lastBuildDate
      element :category
      element :generator
      element :docs
      element :cloud
      element :ttl
      element :image, :class => RSSImage
      element :rating
      element :textInput
      element :skipHours
      element :skipDays

      # iTunes
      element :'itunes:author', :as => :author
      element :'itunes:block', :as => :itunes_block
      element :'itunes:image', :as => :image, :value => :href
      element :'itunes:explicit', :as => :explicit
      element :'itunes:keywords', :as => :keywords
      element :'itunes:new-feed-url', :as => :feed_url
      element :'itunes:name', :as => :owner_name
      element :'itunes:email', :as => :owner_email
      element :'itunes:subtitle', :as => :subtitle
      element :'itunes:summary', :as => :summary

      elements :'itunes:category', :as => :categories, :value => :text
      # elements :'itunes:category', :as => :itunes_categories,
      #   :class => ITunesCategory

      def self.able_to_parse?(xml) #:nodoc:
        xml =~ /\<rss|rdf/
      end
    end
  end
end