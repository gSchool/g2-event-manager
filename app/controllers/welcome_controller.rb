class WelcomeController < ApplicationController
  def index
    @events = Event.all.order(:date).page(params[:page])
  end
end