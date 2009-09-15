class UserPreferencesController < ApplicationController

  before_filter :login_required

  def show  
    @user_preference = UserPreference.find_by_user_id(current_user.id) || UserPreference.new
  end

  def create
    @user_preference = UserPreference.find_by_user_id(current_user.id) || UserPreference.new
    
    @user_preference.update_attributes(params[:user_preference])
    
    @user_preference.user_id = current_user.id
    if @user_preference.save
      flash[:notice] = "Your preferences have been updated."
    end
    
    redirect_to :action => :show
  end

  
end
