# Learn more: http://github.com/javan/whenever


# Refresh the feed parse stats
every 1.day, :at => "11:30pm" do
  runner "FeedParseStat.refresh"
end


#############################################
# Production CRON jobs
#############################################

# Refresh the production caches
every 4.hours do
  command "/home/jamesro/thepeoplesfeed/script/clearCaches.sh > /home/jamesro/cron.log"
end

# Fetch new issue emails
every 10.minutes do
  command "/home/jamesro/thepeoplesfeed/script/getIssues.sh > /home/jamesro/cron.log"
end

# Fetch new feeds
every 30.minutes do 
  runner "Feed.find(:all).each {|feed| feed.update_feed}"
end