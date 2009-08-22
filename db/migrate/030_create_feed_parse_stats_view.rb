class CreateFeedParseStatsView < ActiveRecord::Migration
  def self.up
    execute "create or replace view vw_feed_parse_stats as (select feed_id, dayofyear(parse_start) dayofyear, feed_items_added from feed_parse_logs group by dayofyear(parse_start), feed_id);"
  end

  def self.down

  end
end