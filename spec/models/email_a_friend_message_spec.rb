require File.dirname(__FILE__) + '/../spec_helper'

describe EmailAFriendMessage do
  
  it "should not save with blank emails" do
    EmailAFriendMessage.new.save.should be false
  end
  
  it "should not save with only a recipient email" do
    EmailAFriendMessage.new(:recipient_email_address => 'englert.james@gmail.com').save.should be false
  end
  
  it "should not save with an invalid email domain" do
    EmailAFriendMessage.new(:recipient_email_address => 'englert.james@gmail.com', :sender_email_address => 'jim@baddomainthatdoesnotexist.com').save.should be false
  end
  
end