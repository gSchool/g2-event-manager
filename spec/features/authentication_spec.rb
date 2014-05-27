require 'spec_helper'

feature "User can register, logout & login for the site" do
  context "user logs in with valid info" do
    before :each do
     user_register
    end

    scenario "User can logout and then login after registering" do
      click_on 'Logout'
      expect(page).to have_no_content 'joesmith@example.com'
      user_login
      expect(page).to have_content 'joesmith@example.com'
    end

    scenario "User cannot login with incorrect password" do
      click_on 'Logout'
      user_login("joesmith@example.com", "1111")
      expect(page).to have_content 'User/Password Combination is not correct'
    end
  end
  context "user registration validations" do
    scenario "User cannot register with blank email field" do
     user_register("")
      expect(page).to have_content "Email can't be blank"
    end
    scenario "User cannot register with an already existing email address" do
      user_register
      click_on 'Logout'
      user_register
      expect(page).to have_content "Email has already been taken"
    end
    scenario 'user cannot register with an invalid email address' do
      user_register('jjkawd')
      expect(page).to have_content "Email must be valid"
    end
  end
end