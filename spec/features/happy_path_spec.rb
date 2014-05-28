require 'spec_helper'

feature 'Happy Path' do
  scenario 'user can log in and manage events' do
    user_register
    new_event
    expect(page).to have_content 'Ignite Boulder'
    click_on 'Edit this Event'
    fill_in 'Location', with: 'Fox Theatre'
    click_on 'Update Event'
    expect(page).to have_content 'Fox Theatre'
    expect(page).to_not have_content 'Boulder Theatre'
    click_on 'Delete this Event'
    expect(page).to_not have_content 'Ignite Boulder'
  end

  scenario 'Registered user can see all the events they signed up for' do
    user_register
    new_event
    click_on 'Logout'
    user_register("s@s.com")
    click_on 'See All Events'
    click_on 'Ignite Boulder'
    click_on 'RSVP for this Event'
    click_on 's@s.com'
    within '#attending' do
      expect(page).to have_content 'Ignite Boulder'
    end
  end
  scenario 'Registered user can request and receive a new password' do
    user_register
    click_on 'Logout'
    click_on 'Login'
    click_on 'Forgot password'
    fill_in 'Email', with: "joesmith@example.com"
    click_on 'Reset password'
    expect(page).to have_content "Email has been sent"
  end
end