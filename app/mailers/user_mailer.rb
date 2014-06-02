class UserMailer < ActionMailer::Base
  default from: 'info@example.com'

  def forgot_password(user, token)
    @user = user
    @link = "/reset_password/#{token}"
    mail(to: @user.email, subject: 'Password reset')
  end
end
