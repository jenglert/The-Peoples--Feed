require 'resolv'
class EmailSubscription < ActiveRecord::Base
  
  # A constant for the desired email address.
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
  
  # Validates the presence of an email address
  validates_presence_of :email
  
  # Validates the format of an email address
  validates_format_of :email, :with => EMAIL_ADDRESS_FORMAT
  
  validates_uniqueness_of :email
  
  # Validates that the domain exists
  validate :domain_exists?
  
  def domain_exists?
    result = self.email.match(/\@(.+)/)
    return if result.nil?
    
    domain = result[1]
    Resolv::DNS.open do |dns|
      @mx = dns.getresources(domain, Resolv::DNS::Resource::IN::MX)
    end
    
    if @mx.size <= 0 
      errors.add_to_base('Please make sure you have the correct email domain.')
    end
    
  end
  

  
end
