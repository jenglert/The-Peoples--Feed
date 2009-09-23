class MakeBlogPostLengthVeryLong < ActiveRecord::Migration
  def self.up
    change_column :blog_posts, :post, :text
  end

  def self.down
  end
end
