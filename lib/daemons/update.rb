#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "production"

require File.dirname(__FILE__) + "/../../config/environment"

$running = true
Signal.trap("TERM") do 
  $running = false
end

while($running) do
  
  # Replace this with your code
  ActiveRecord::Base.logger.info "This daemon is still running at #{Time.now}.\n"
  
  Feed.find(:all).each {|feed| feed.update_feed}
  
  # Updating all the feeds usually takes pretty long so it's not necessary to sleep for that long.
  sleep 5 
end