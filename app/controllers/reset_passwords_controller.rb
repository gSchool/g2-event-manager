class ResetPasswordsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user
      token = SecureRandom.uuid
      @user.update(token: token)
      UserMailer.forgot_password(@user, token).deliver
    end

    redirect_to new_login_path, notice: 'An email has been sent with instructions on how to reset your password'
  end

  def edit
    @user = User.find_by(token: params[:token])
  end

  def update
    @user = User.find_by(token: params[:token])
    @user.update(password: params[:user][:password])
    redirect_to '/', notice: "Password Updated"
  end
end