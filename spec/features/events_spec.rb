require 'spec_helper'

feature 'events managment' do

  before do
    visit '/'
    click_on 'Register'
    fill_in 'Email', with: 's@s.com'
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
    15.times do
      Event.create(name: 'things')
    end
  end

  scenario 'only a user can add an event' do
    expect(page).to have_content 'Ignite Boulder'
    expect(page).to have_content '2014-05-15'
    expect(page).to have_content 'Boulder Theatre'
  end

  scenario 'user can see all events they created on their homepage' do
    click_on 's@s.com'
    within('#my_events') do
      expect(page).to have_content 'My events'
      expect(page).to have_content 'Ignite Boulder'
      expect(page).to have_content '2014-05-15'
      expect(page).to have_content 'Boulder Theatre'
    end
  end

  scenario 'user can click on event to see details' do
    click_on 'Ignite Boulder'
    expect(page).to have_content 'Ignite Boulder'
    expect(page).to have_content '2014-05-15'
    expect(page).to have_content 'Boulder Theatre'
    expect(page).to have_content 'Awesomeness'
    expect(page).to have_content 'Boulder Startup Week'
    expect(page).to have_content '500'
  end

  scenario 'Guests cannot create an event' do
    click_on 'Logout'
    click_on 'See All Events'
    click_on 'Add Event'
    expect(page).to have_content('You must login to create an event')
  end

  scenario 'there are only 10 events per page' do
    visit '/events'
    expect(page).to have_link '2'
  end

  scenario 'a user can register for an event' do
    click_on 'Logout'
    click_on 'Register'
    fill_in 'Email', with: 'test@s.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_on 'Submit'
    click_on 'See All Events'
    click_on 'Ignite Boulder'
    click_on 'RSVP for this Event'
    expect(page).to have_content('Successfully registered')
    expect(page).to have_content('Capacity: 499')
    end

  scenario 'a user can be waitlisted for a full event' do
    click_on 'Logout'
    click_on 'Register'
    fill_in 'Email', with: 'test1@s.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_on 'Submit'
    click_on 'See All Events'
    event = Event.find_by_name('Ignite Boulder')
    event.update(capacity: 0)
    click_on 'Ignite Boulder'
    click_on 'RSVP for this Event'
    expect(page).to have_content 'You have been waitlisted'
  end

  scenario 'only a user can view open spaces for an event' do
    visit '/events'
    click_on 'Ignite Boulder'
    expect(page).to have_content 'Capacity: 500'
    click_on 'Logout'
    visit '/events'
    click_on 'Ignite Boulder'
    expect(page).to_not have_content 'Capacity: 500'
  end

end