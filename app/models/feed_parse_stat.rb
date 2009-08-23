class FeedParseStat < ActiveRecord::Base
  
  def self.refresh
    refresh_day(Time.new)
  end
  
  def self.refresh_day(time)
    # Remove any stats that might exist for today.
    self.destroy_all(["parse_day >= ? and parse_day <= ?", time.beginning_of_day, time.end_of_day])
    
    feed_parse_stats = {}
    
    for feed_parse_log in FeedParseLog.find(:all, :conditions => ["parse_start >= ? and parse_start <= ?", time.beginning_of_day, time.end_of_day]) do
        
        feed_parse_stat = feed_parse_stats[feed_parse_log.feed_id] || FeedParseStat.new(:feed_id => feed_parse_log.feed_id, :parse_day => time.beginning_of_day, :feed_items_added => 0)
        
        feed_parse_stats.store(feed_parse_log.feed_id, feed_parse_stat)
              
        feed_parse_stat.feed_items_added += feed_parse_log.feed_items_added      
    end
    
    feed_parse_stats.each { |feed_parse_stat| feed_parse_stat[1].save! }
  end
end
