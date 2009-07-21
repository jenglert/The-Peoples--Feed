class AddUrlToFeed < ActiveRecord::Migration
  def self.up
    add_column :feeds, :url, :string
  end

  def self.down

  end
end
