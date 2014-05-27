class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    User.find_by(id: session[:current_user_id]) if logged_in?
  end

  def logged_in?
    if session[:current_user_id]
      true
    else
      false
    end
  end

  def register_user_for_event(user, event)
    Registration.create(event_id: event.id, user_id: user.id)
  end

  def unregister_user_for_event(user, event)
    event.capacity += 1
    Registration.find_by(event_id: event.id, user_id: user.id).destroy
  end

  helper_method :current_user, :logged_in?
  helper_method :unregister_user_for_event
  helper_method :register_user_for_event
end
