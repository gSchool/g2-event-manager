module UserMethods
  def user_register(email="joesmith@example.com", password="1234", confirmation="1234")
    visit '/'
    click_on 'Register'
    fill_in 'user[email]', with: email
    fill_in 'user[password]', with: password
    fill_in 'user[password_confirmation]', with: confirmation
    click_on 'Submit'
  end

  def user_login(email="joesmith@example.com", password="1234")
    click_link 'Login'
    fill_in 'user[email]', with: email
    fill_in 'user[password]', with: password
    click_button 'Submit'

  end
end
