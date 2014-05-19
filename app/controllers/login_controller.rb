class LoginController < ApplicationController
  def destroy
    @_current_user = session[:current_user_id] = nil
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:user][:email]).try(:authenticate, params[:user][:password])

    if @user
      session[:current_user_id] = @user.id
      redirect_to root_path
    else
      @user = User.new
      flash.now[:error] = "User/Password Combination is not correct"
      render :new
    end

  end
end