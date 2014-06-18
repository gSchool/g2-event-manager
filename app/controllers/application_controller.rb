class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include ViewHelpers

  helper_method :time_to_12_hour

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

  helper_method :current_user, :logged_in?
end