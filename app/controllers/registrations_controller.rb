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
    user = current_user
    event.capacity += 1
    Registration.find_by(event_id: event.id, user_id: user.id).destroy

    flash[:notice] = "You are no longer registered for this event"

    redirect_to event
  end

end