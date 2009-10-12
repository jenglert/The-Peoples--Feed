class ConsumerMailer < ActionMailer::Base

  def email_a_friend(email_a_friend_settings)
    recipients email_a_friend_settings.recipient_email_address
    from "webmaster@thepeoplesfeed.com"
    subject "#{email_a_friend_settings.title} - The People's Feed"
    body :email_a_friend_settings => email_a_friend_settings
  end  
  
  def forgot_password(email, password)
    recipients email
    from "webmaster@thepeoplesfeed.com"
    subject "Your password from The People's Feed"
    body :password => password
  end

end
