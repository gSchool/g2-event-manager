class EventsController < ApplicationController

  def index
    @events = Event.all.order(:date).stuff(params[:page])
  end

  def new
    if !session[:current_user_id]
      @events = Event.all.stuff(params[:page])
      flash[:notice] = "You must login to create an event"
      render 'index'
    else
      @event = Event.new
    end
  end

  def create
    @user = User.find(session[:current_user_id]) if session[:current_user_id]
    event = Event.create(event_params.merge(:user => @user))
    event.attendances << Attendance.new(user: @user, role: :creator)
    redirect_to event
  end

  def show
    @user = User.find(session[:current_user_id]) if session[:current_user_id]
    @event = Event.find(params[:id])
  end

  def edit
    @event = Event.find(params[:id])
    user = User.find(session[:current_user_id]) if session[:current_user_id]
    if @event.user.id != user.id
      flash[:notice] = "You can't be here"
      redirect_to '/events'
    end
  end

  def update
    @user = User.find(session[:current_user_id]) if session[:current_user_id]
    @event = Event.find(params[:id])
    @event.update(event_params)
    redirect_to @event
  end

  def destroy
    Event.find(params[:id]).destroy
    redirect_to '/events'
  end

  def register
    user = User.find(session[:current_user_id]) if session[:current_user_id]
    event = Event.find(params[:id])
    if event.tickets_remaining > 0
      event.attendances.create(user: user, role: :guest)
      flash[:notice] = "Successfully registered"
    else
      event.attendances.create(user: user, role: :waitlist)
      flash[:notice] = "You have been waitlisted"
    end
    redirect_to event
  end

  def unregister
    user = User.find(session[:current_user_id]) if session[:current_user_id]
    event = Event.find(params[:id])
    user.attendances(event: event).clear
    redirect_to event
  end

  private
  def event_params
    params.require(:event).permit(:name, :date, :description, :location, :capacity, :category)
  end
end

