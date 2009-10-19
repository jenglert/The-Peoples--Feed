# Module that can be included for some extra email validation functions
require 'resolv'
module EmailValidationHelper 
  
  # A constant regex for the desired email address.
  EMAIL_ADDRESS_FORMAT = begin
    qtext = '[^\\x0d\\x22\\x5c\\x80-\\xff]'
    dtext = '[^\\x0d\\x5b-\\x5d\\x80-\\xff]'
    atom = '[^\\x00-\\x20\\x22\\x28\\x29\\x2c\\x2e\\x3a-' +
      '\\x3c\\x3e\\x40\\x5b-\\x5d\\x7f-\\xff]+'
    quoted_pair = '\\x5c[\\x00-\\x7f]'
    domain_literal = "\\x5b(?:#{dtext}|#{quoted_pair})*\\x5d"
    quoted_string = "\\x22(?:#{qtext}|#{quoted_pair})*\\x22"
    domain_ref = atom
    sub_domain = "(?:#{domain_ref}|#{domain_literal})"
    word = "(?:#{atom}|#{quoted_string})"
    domain = "#{sub_domain}(?:\\x2e#{sub_domain})*"
    local_part = "#{word}(?:\\x2e#{word})*"
    addr_spec = "#{local_part}\\x40#{domain}"
    pattern = /\A#{addr_spec}\z/
  end
  
  # Performs email validation.  Returns an array of issues with the email
  def self.validate_email(email, email_field_name = 'email')
    errors = []
    
    if !(email)
      errors << "Please enter your #{email_field_name} address."  
    elsif !(EMAIL_ADDRESS_FORMAT =~ email)
      errors << "Please check the format of your #{email_field_name} address."
    elsif !domain_exists?(email)
      errors << "The #{email_field_name} address does not appear to be valid."
    end
    
    errors
  end

 private  

  def self.domain_exists?(email)
    result = email.match(/\@(.+)/)
    return if result.nil?
    
    domain = result[1]
    mx = -1
    Resolv::DNS.open do |dns|
      mx = dns.getresources(domain, Resolv::DNS::Resource::IN::MX)
    end
    
    mx.size > 0 ? true : false   
    
  rescue
    return true
  end
  
end