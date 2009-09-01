class EmailSubscriptionsController < ApplicationController
  
  def new
    @email_subscription = EmailSubscription.new
  end
  
  def create
    @email_subscription = EmailSubscription.new(params[:email_subscription])
    
    if !@email_subscription.save
      render :new
    end
  end
  
end