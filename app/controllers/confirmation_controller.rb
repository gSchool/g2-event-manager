class ConfirmationController < ApplicationController

  def new
    @user = User.find_by(token: params[:token])
    @user.update(email_confirmed: true)
    flash[:notice] = 'Email confirmed, you can now login'

    redirect_to root_path
  end
end
