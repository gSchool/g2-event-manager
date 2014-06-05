class UserMailer < ActionMailer::Base
  default from: 'info@eventmanager.com'

  def forgot_password(user)
    @user = user
    mail(to: @user.email, subject: 'Password reset')
  end
end
