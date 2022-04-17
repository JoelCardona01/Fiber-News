class SessionsController < ApplicationController
  
  def logout
    session[:user_id] = nil
    redirect_to request.referrer
  end
  
  def omniauth
    @user = User.from_omniauth(auth)
    @user.save
    session[:user_id] = @user.id
    redirect_to submissions_path
  end
  private
  def auth
    request.env['omniauth.auth']
  end
  
end
