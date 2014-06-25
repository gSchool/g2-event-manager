class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(allowed_parameters)
    if @user.save
      token = SecureRandom.uuid
      @user.update(token: token)
      calendar_token = SecureRandom.uuid
      @user.update(calendar_token: calendar_token)
      UserMailer.new_registration(@user).deliver
      flash[:notice] = 'A confirmation email has been sent to your email address'
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
      @calendar_token = current_user.calendar_token
    else
      redirect_to root_path
    end
  end

  def calendar
    @user = User.find_by_calendar_token(params[:token])

    @events = @user.associated_events

    post = Event.to_ics(@events, @user)

    render text: post, mime_type: Mime::Type.new("text/calendar")
  end

  private

  def allowed_parameters
    params.require(:user).permit(:email, :password, :password_confirmation, :email_confirmed)
  end
end