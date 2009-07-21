require File.dirname(__FILE__) + '/mrss_content'
require File.dirname(__FILE__) + '/mrss_credit'
require File.dirname(__FILE__) + '/mrss_restriction'

module Feedzirra
  module Parser
    # == Summary
    # Parser for dealing with RDF feed entries.
    #
    # == Attributes
    # * title
    # * url
    # * author
    # * content
    # * summary
    # * published
    # * categories
    class RSSEntry
      include SAXMachine
      include FeedEntryUtilities

      # RSS 2.0 elements
      element :title
      element :link, :as => :url
      element :description, :as => :summary
      element :author
      elements :category, :as => :categories
      element :comments
      element :guid, :as => :id
      element :pubDate, :as => :published
      element :source
      element :enclosure, :value => :length, :as => :enclosure_length
      element :enclosure, :value => :type, :as => :enclosure_type
      element :enclosure, :value => :url, :as => :enclosure_url


      # RDF elements
      element :"dc:date", :as => :published
      element :"dc:Date", :as => :published
      element :"dcterms:created", :as => :published
      element :issued, :as => :published
      element :"content:encoded", :as => :content
      element :"dc:creator", :as => :author
      element :"dcterms:modified", :as => :updated

      # MediaRSS support
      element :'media:thumbnail', :as => :media_thumbnail, :value => :url
      element :'media:thumbnail', :as => :media_thumbnail_width, :value => :width
      element :'media:thumbnail', :as => :media_thumbnail_height, :value => :height
      element :'media:description', :as => :media_description

      element :'media:rating', :as => :rating
      element :'media:rating', :value => :scheme, :as => :rating_scheme

      element :'media:title', :as => :media_title
      element :'media:keywords', :as => :media_keywords

      element :'media:category', :as => :media_category
      element :'media:category', :value => :scheme, :as => :media_category_scheme
      element :'media:category', :value => :label, :as => :media_category_label

      element :'media:hash', :as => :media_hash
      element :'media:hash', :value => :algo, :as => :media_hash_algo

      element :'media:player', :value => :url, :as => :media_player_url
      element :'media:player', :value => :width, :as => :media_player_width
      element :'media:player', :value => :height, :as => :media_player_height

      elements :'media:credit', :as => :credits, :class => MRSSCredit

      element :'media:copyright', :as => :copyright
      element :'media:copyright', :as => :copyright_url, :value => :url

      element :'media:restriction', :as => :media_restriction, :class => MRSSRestriction

      elements :'media:content', :as => :media_content, :class => MRSSContent

      # iTunes
      element :'itunes:author', :as => :author
      element :'itunes:block', :as => :itunes_block
      element :'itunes:duration', :as => :duration
      element :'itunes:explicit', :as => :explicit
      element :'itunes:keywords', :as => :keywords
      element :'itunes:subtitle', :as => :subtitle
      element :'itunes:summary', :as => :summary
    end
  end
end