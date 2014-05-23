class RegistrationsController < ApplicationController

  def create
    user = User.find(session[:current_user_id]) if session[:current_user_id]
    event = Event.find(params[:event_id])
    if event.tickets_remaining > 0
      event.registrations.create(user: user, role: :guest)
      flash[:notice] = "Successfully registered"
    else
      event.add_to_waitlist(user)
      flash[:notice] = "You have been waitlisted"
    end
    redirect_to event
  end

  def destroy
    user = User.find(session[:current_user_id]) if session[:current_user_id]
    event = Event.find(params[:event_id])
    event.remove_from_waitlist(user)
    redirect_to event
  end

end