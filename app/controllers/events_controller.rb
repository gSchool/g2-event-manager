class EventsController < ApplicationController

  def index
    @events = Event.all
  end

  def new
    if !session[:current_user_id]
      @events = Event.all
      flash[:notice] = "You must login to create an event"
      render :index
    else
      @event = Event.new
    end
  end

  def create
    Event.create(event_params)
    redirect_to '/events'
  end

  def show
    @event = Event.find(params[:id])
  end

  private
  def event_params
    params.require(:event).permit(:name, :date, :description, :location, :capacity, :category)
  end
end

