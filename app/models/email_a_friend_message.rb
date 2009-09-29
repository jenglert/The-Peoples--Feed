class EmailAFriendMessage < ActiveRecord::Base
  # Validates that the domain exists
  validate :emails_are_valid?
  
  validates_presence_of :recipient_email_address
  validates_presence_of :sender_email_address
  
  # Validate that both email fields are correct.
  def emails_are_valid?
    EmailValidationHelper.validate_email self.recipient_email_address, "friend's email"
    EmailValidationHelper.validate_email self.sender_email_address, "your email"
  end
end
