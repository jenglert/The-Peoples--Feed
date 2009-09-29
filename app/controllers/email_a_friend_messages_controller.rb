class EmailAFriendMessagesController < ApplicationController
  
  # Unimplemnted at this point. Eventually, we might have functionality where a consumer could email a friend about the
  # site in general.
  def new
    @email_a_friend_message = EmailAFriendMessage.new
    
    @email_a_friend_message.url = "http://#{request.host}:#{request.port if request.port != 80}/" if @email_a_friend_message.url.nil?
    
  end

    
  def create
    @email_a_friend_message  = EmailAFriendMessage.new(params[:email_a_friend_message])
    
    if @email_a_friend_message.save
      flash[:notice] = "Your message is currently being sent."
      ConsumerMailer.deliver_email_a_friend(@email_a_friend_message)
      redirect_to @email_a_friend_message.url
      return
    end
    
    render :action => 'new'
  end

end
