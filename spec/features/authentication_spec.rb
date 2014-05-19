require 'spec_helper'

feature "User can register, logout & login for the site" do
  context "user logs in with valid info" do
    before :each do
      visit '/'
      click_on 'Register'
      fill_in 'user[email]', with: "joesmith@example.com"
      fill_in 'user[password]', with: "1234"
      fill_in 'user[password_confirmation]', with: "1234"
      click_on 'Submit'
    end

    scenario "User can logout and then login after registering" do
      click_on 'Logout'
      expect(page).to have_no_content 'joesmith@example.com'
      click_link 'Login'
      fill_in 'user[email]', with: "joesmith@example.com"
      fill_in 'user[password]', with: "1234"
      click_button 'Submit'
      expect(page).to have_content 'joesmith@example.com'
    end

    scenario "User cannot login with incorrect password" do
      click_on 'Logout'

      click_link 'Login'
      fill_in 'user[email]', with: "joesmith@example.com"
      fill_in 'user[password]', with: "1212"
      click_button 'Submit'
      expect(page).to have_content 'User/Password Combination is not correct'
    end
  end
  context "user registration validations" do
    scenario "User cannot register with blank email field" do
      visit '/'
      click_on 'Register'
      fill_in 'user[email]', with: ""
      fill_in 'user[password]', with: "1234"
      fill_in 'user[password_confirmation]', with: "1234"
      click_on 'Submit'
      expect(page).to have_content "Email can't be blank"
    end
  end
end