class AddFeedParseLogsIndex < ActiveRecord::Migration
  def self.up
    add_index :feed_parse_logs, :feed_id
  end

  def self.down
    
  end
end


    
