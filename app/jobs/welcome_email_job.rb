class WelcomeEmailJob
  include SuckerPunch::Job

  def send_welcome_email(user)
    UserMailer.new_registration(user).deliver
  end
end
