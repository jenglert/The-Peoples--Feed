class AddDisabledReasonToFeed < ActiveRecord::Migration
  def self.up
    add_column :feeds, :disabled_reason, :string
  end

  def self.down
    drop_column :feeds, :disabled_reason, :string
  end
end
