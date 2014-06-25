class PasswordResetEmailJob
  include SuckerPunch::Job

  def send_password_reset_email(user)
    UserMailer.forgot_password(user).deliver
  end
end
