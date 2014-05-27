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
    event = Event.create(event_params.merge(:user => current_user))
    event.registrations << Registration.new(user: current_user, role: :creator)
    redirect_to event
  end

  def show
    @event = Event.find(params[:id])
  end

  def edit
    @event = Event.find(params[:id])
    if @event.user.id != current_user.id
      flash[:notice] = "You can't be here"
      redirect_to '/events'
    end
  end

  def update
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

