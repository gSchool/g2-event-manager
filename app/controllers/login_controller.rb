class LoginController < ApplicationController
  def destroy
    @_current_user = session[:current_user_id] = nil
    redirect_to root_path
  end
end