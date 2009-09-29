class EmailSubscription < ActiveRecord::Base
  
  # Validates the presence of an email address
  validates_presence_of :email
  
  validates_uniqueness_of :email
  
  # Validates that the domain exists
  validate :validate_email?
  
  def validate_email? 
    validation_errors = EmailValidationHelper.validate_email(self.email)
    errors.add_to_base validation_errors if validation_errors.length > 0
  end
end
