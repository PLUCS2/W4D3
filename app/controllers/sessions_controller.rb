class SessionsController < ApplicationController
  before_action :new , only: [:no_relogin]

  def no_relogin 
    if logged_in? 
      redirect_to cats_url
    end

  end


  def new
    render :new
  end 

  def create 
    user = User.find_by_credentials(params[:user][:user_name], params[:user][:password])
    if user 
      session[:session_token] = user.reset_session_token!
      redirect_to cats_url
    else 
      flash.now[:errors] = ["Invalid credentials"]
      render :new
    end
  end 

  def destroy
    logout!
    # current_user.reset_session_token!
    # session[:session_token] = nil 
    redirect_to new_session_url
  end 


end 