class AlterCategoryAddVisible < ActiveRecord::Migration
  def self.up
    add_column :categories, :visible, :boolean, :default => true
  end

  def self.down

  end
end
