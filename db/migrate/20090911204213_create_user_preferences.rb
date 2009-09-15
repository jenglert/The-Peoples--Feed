class CreateUserPreferences < ActiveRecord::Migration
  def self.up
    create_table :user_preferences do |t|
      
      t.integer :user_id, :allow_nil => false
      t.boolean :show_ads
      t.integer :favorite_category
      t.integer :favorite_feed
      t.boolean :hide_member_info, :default => true
      
      t.timestamps
    end
  end

  def self.down
    drop_table :user_preferences
  end
end
