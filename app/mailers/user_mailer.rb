class UserMailer < ActionMailer::Base
  default from: 'info@example.com'

  def forgot_password(user)
    @user = user
    mail(to: @user.email, subject: 'Password reset')
  end
end
