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
    unregister_user_for_event(current_user, event)
    flash[:notice] = "You are no longer registered for this event"

    redirect_to event
  end

end