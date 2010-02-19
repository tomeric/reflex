class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end
  
  def create    
    @user_session = UserSession.new(params[:user_session])
    
    @user_session.save do |success|
      if success
        flash[:notice] = "Login successful!"
        redirect_to @user_session.record
      else
        render :action => :new
      end
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to :back
  end
end
