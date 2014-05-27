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
    event.registrations << Registration.new(user: @user, role: :creator)
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

  private


  def event_params
    params.require(:event).permit(:name, :date, :description, :location, :capacity, :category)
  end
end

