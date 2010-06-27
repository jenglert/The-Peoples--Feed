class AddDisabledToFeed < ActiveRecord::Migration
  def self.up
    add_column :feeds, :disabled, :boolean
  end

  def self.down
    drop_column :feeds, :disabled, :boolean
  end
end
