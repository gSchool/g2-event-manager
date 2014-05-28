module UserMethods
  def user_register(email="joesmith@example.com", password="Gschool123", confirmation="Gschool123")
    visit '/'
    click_on 'Register'
    fill_in 'user[email]', with: email
    fill_in 'user[password]', with: password
    fill_in 'user[password_confirmation]', with: confirmation
    click_on 'Submit'
  end

  def user_login(email="joesmith@example.com", password="Gschool123")
    click_link 'Login'
    fill_in 'user[email]', with: email
    fill_in 'user[password]', with: password
    click_button 'Submit'
  end
end
