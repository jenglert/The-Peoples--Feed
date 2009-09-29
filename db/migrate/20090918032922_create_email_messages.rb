class CreateEmailMessages < ActiveRecord::Migration
  def self.up
    create_table :email_a_friend_messages do |t|
      
      t.string :recipient_email_address
      t.string :sender_email_address
      t.string :url
      t.string :title
      t.text :message
      t.timestamp :date_sent

      t.timestamps
    end
  end

  def self.down
    drop_table :email_messages
  end
end
