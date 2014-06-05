class EventsController < ApplicationController

  def index
    @events = Event.all.order(:date).stuff(params[:page])
  end

  def new
    if logged_in?
      @event = Event.new
    else
      @events = Event.all.stuff(params[:page])
      flash[:notice] = "You must login to create an event"
      render 'index'
    end
  end

  def create
    @event = Event.new(event_params.merge(:user => current_user))
    if @event.save
      @event.registrations << Registration.new(user: current_user, role: :creator)
      redirect_to event_path(@event)
    else
      render new_event_path
    end
  end

  def show
    find_event
  end

  def edit
    find_event
    if @event.user.id != current_user.id
      flash[:notice] = "You can't be here"
      redirect_to events_path
    end
  end

  def update
    find_event
    @event.update(event_params)
    redirect_to event_path
  end

  def destroy
    Event.find(params[:id]).destroy
    redirect_to events_path
  end

  private


  def event_params
    params.require(:event).permit(:name, :date, :description, :location, :capacity, :category, :event_pic)
  end

  def find_event
    @event = Event.find(params[:id])
  end
end

