class UserMailer < ActionMailer::Base
  default from: 'info@example.com'

  def forgot_password(user, link)
    @user = user
    @link = link
    @link = "#{users_path}/#{SecureRandom.uuid}"
    mail(to: @user, subject: 'Password reset')
  end
end
