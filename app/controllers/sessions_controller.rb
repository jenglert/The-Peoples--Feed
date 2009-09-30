# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  # render new.rhtml
  def new
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?

      # Always drop the logged in cookie.
      cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => Time.new + 360.days }

      default = '/'

      puts "referrer:" + request.referrer
      # Attempt to determine if we came from the login page, if so, do nothing. If not, go to the page we used to be at
      default = request.referrer if !request.referrer.include?('sessions')

      redirect_back_or_default(default)
      flash[:notice] = "Logged in successfully"
    else
      flash[:error] = "Username/Password not recognized.  Please try again."
      render :action => 'new'
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end
end
