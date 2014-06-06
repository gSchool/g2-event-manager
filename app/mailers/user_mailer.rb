class UserMailer < ActionMailer::Base
  default from: 'info@eventmanager.com'

  def forgot_password(user)
    @user = user
    mail(to: @user.email, subject: 'Password reset')
  end

  def new_registration(user)
    @user = user
    mail(to: @user.email, subject: 'Confirm your email to complete registration')
  end
end
