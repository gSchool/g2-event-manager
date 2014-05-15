class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(allowed_parameters)
    @user.save
    session[:current_user_id] = @user.id
    current_user
    redirect_to root_path
  end

  private

  def allowed_parameters
    params.require(:user).permit(:email, :password)
  end
end