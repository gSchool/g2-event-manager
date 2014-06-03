class WelcomeController < ApplicationController
  def index
    @events = Event.all.order(:date).stuff(params[:page])
  end
end