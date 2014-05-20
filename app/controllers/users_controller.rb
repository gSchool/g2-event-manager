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
    if session[:current_user_id]
      @user = User.find(session[:current_user_id])
      @events = @user.created_events
      @attending = @user.attended_events
      @waitlist = @user.waitlisted_events
    else
      redirect_to root_path
    end
  end

  private

  def allowed_parameters
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end