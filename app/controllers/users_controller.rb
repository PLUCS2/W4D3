class UsersController < ApplicationController
  before_action :new , only: [:no_relogin] # :no_relogin, only: [:login ]

  def no_relogin 
    if logged_in? 
      redirect_to cats_url
    end
  end


  def new 
    render :new
  end

  def create 
    @user = User.new(user_params) 
    # debugger
    if @user.save! 
      # debugger
      login!(@user)
      redirect_to cats_url 
    else
      flash.now[:errors] = @user.errors.full_messages 
      render :new 
    end
  end


  private 
  def user_params 
    params.require(:user).permit(:user_name, :password) 
  end

end
