class UserAddAdministrator < ActiveRecord::Migration
  def self.up
    add_column :users, :admin, :boolean, :default => 0
  end

  def self.down
  end
end
