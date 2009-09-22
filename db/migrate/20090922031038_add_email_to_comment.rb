class AddEmailToComment < ActiveRecord::Migration
  def self.up
    add_column :comments, :email, :string
  end

  def self.down
  end
end
