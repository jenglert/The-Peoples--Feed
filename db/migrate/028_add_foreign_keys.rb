class AddForeignKeys < ActiveRecord::Migration
  def self.up
    execute "alter table feed_item_categories add constraint category_fk foreign key (category_id) references categories(id);"
    change_column :feed_item_categories, :feed_item_id, :integer
    execute "alter table feed_item_categories add constraint feed_item_fk foreign key (feed_item_id) references feed_items(id);"
    execute "alter table feed_items add constraint feed_fk foreign key (feed_id) references feeds(id);"
    execute "alter table feed_parse_logs add constraint fpl_feed_fk foreign key (feed_id) references feeds(id);"
  end

  def self.down

  end
end
