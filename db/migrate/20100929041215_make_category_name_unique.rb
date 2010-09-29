class MakeCategoryNameUnique < ActiveRecord::Migration
  def self.up
    
    categories = Category.find_by_sql("select * from categories where name in (select name from categories group by name having count(*) > 1)")
    categories_by_name = {}
    puts categories.count
    categories.each do |category|
      category.destroy if !categories_by_name.include? category.name
      categories_by_name[category.name] = category
    end
  
    execute "create unique index category_name_uidx on categories(name)"
  end

  def self.down
  end
end
