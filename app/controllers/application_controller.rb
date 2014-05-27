class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    if session[:current_user_id]
      @_current_user ||= session[:current_user_id] &&
        User.find_by(id: session[:current_user_id])
    else
      nil
    end
  end

  def logged_in?
    if session[:current_user_id]
      true
    else
      false
    end
  end

  helper_method :current_user, :logged_in?

end
