class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(allowed_parameters)
    if @user.save
      session[:current_user_id] = @user.id
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    if logged_in?
      @events = current_user.created_events
      @attending = current_user.attended_events
      @waitlist = current_user.waitlisted_events
    else
      redirect_to root_path
    end
  end

  def reset_password
    user = User.find(params[:id])
    user.lost_password
    link = lost_password_path + "/?token=#{user.token}"
    UserMailer.forgot_password(user, link).deliver
    redirect_to login_path, notice: "Your password has been sent to you"
  end

  def reset_password_form
    @user = User.find(params[:id])
    token = params[:token]
    if @user.token == token
      @user.token=nil
    else
      redirect_to login_path, notice: "Not allowed to access this page"
    end
  end

  private

  def allowed_parameters
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end