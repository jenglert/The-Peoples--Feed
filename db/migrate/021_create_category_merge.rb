class CreateCategoryMerge < ActiveRecord::Migration
  def self.up
    create_table :category_merges do |t|
      t.string :merge_src
      t.integer :merge_target

      t.timestamps
    end
  end

  def self.down
    drop_table :category_merges
  end
end
