require 'spec_helper'

feature 'Happy Path' do
  scenario 'user can log in and manage events' do
    visit '/'
    click_on 'Register'
    fill_in 'Email', with: 'r@r.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_on 'Submit'
    click_on 'See All Events'
    click_on 'Add Event'
    fill_in 'Name', with: 'Ignite Boulder'
    page.find('#event_date').set('2014-05-15')
    fill_in 'Description', with: 'Awesomeness'
    fill_in 'Location', with: 'Boulder Theatre'
    fill_in 'Capacity', with: 500
    fill_in 'Category', with: 'Boulder Startup Week'
    click_on 'Create Event'
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
    visit '/'
    click_on 'Register'
    fill_in 'Email', with: 'r@r.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_on 'Submit'
    click_on 'See All Events'
    click_on 'Add Event'
    fill_in 'Name', with: 'Ignite Boulder'
    page.find('#event_date').set('2014-05-15')
    fill_in 'Description', with: 'Awesomeness'
    fill_in 'Location', with: 'Boulder Theatre'
    fill_in 'Capacity', with: 500
    fill_in 'Category', with: 'Boulder Startup Week'
    click_on 'Create Event'
    click_on 'Logout'
    click_on 'Register'
    fill_in 'Email', with: 's@s.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_on 'Submit'
    click_on 'See All Events'
    click_on 'Ignite Boulder'
    click_on 'RSVP for this Event'
    click_on 's@s.com'
    within '#attending' do
      expect(page).to have_content 'Ignite Boulder'
    end
  end
end