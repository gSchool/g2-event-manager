class RegistrationsController < ApplicationController

  def create
    event = Event.find(params[:event_id])
    if event.tickets_remaining > 0
      event.registrations.create(user: current_user, role: :guest)
      flash[:notice] = "Successfully registered"
    else
      event.registrations.create(user: current_user, role: :waitlist)
      flash[:notice] = "You have been waitlisted"
    end
    redirect_to event
  end

  def destroy
    event = Event.find(params[:event_id])
    current_user.registrations(event: event).clear
    redirect_to event
  end

end