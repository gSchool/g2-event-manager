require 'spec_helper'

feature 'events managment' do

  before do
    event = Event.create!(
      name: "Test Meetup",
      location: "Boulder, CO",
      date: 1.days.from_now,
      description: "This is a description",
      capacity: 1,
      category: "test"
    )
    user = User.new(email: 'bob@bob.com', password: '12341234', password_confirmation: '12341234')
    Registration.create!(event: event, user: user, role: :guest)
    user_register('s@s.com')
    new_event
  end

  scenario "user gets redirected to the newly created event page after they created the event" do
    expect(page).to have_content "Edit this Event"
  end

  scenario 'user can see all events they created on their homepage' do
    click_on 's@s.com'
    within('#my_events') do
      expect(page).to have_content 'My events'
      expect(page).to have_content 'Ignite Boulder'
      expect(page).to have_content 'Boulder Theatre'
    end
  end

  scenario 'user can click on event to see details' do
    visit '/'
    click_on 'See All Events'
    click_on 'Ignite Boulder'
    expect(page).to have_content 'Ignite Boulder'
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

  scenario 'a user can register for an event' do
    click_on 'Logout'
    user_register
    click_on 'See All Events'
    click_on 'Ignite Boulder'
    click_on 'RSVP for this Event'
    expect(page).to have_content('Successfully registered')
    expect(page).to have_content('Tickets Remaining: 499')
  end

  scenario 'a user can be waitlisted for a full event and un-waitlist' do
    click_on 'Logout'
    user_register
    click_on 'See All Events'
    click_on 'Test Meetup'
    click_on 'Add me to Wait List'
    expect(page).to have_content 'You have been waitlisted'
    click_on 'Remove me from Wait List'
    expect(page).to have_link 'Add me to Wait List'
  end

  scenario 'only a user can view open spaces for an event' do
    visit '/events'
    click_on 'Ignite Boulder'
    expect(page).to have_content 'Tickets Remaining: 500'
    click_on 'Logout'
    visit '/events'
    click_on 'Ignite Boulder'
    expect(page).to_not have_content 'Tickets Remaining: 500'
  end

  scenario 'there are only 10 events per page' do
    15.times do
      create_event
    end
    visit '/events'
    expect(page).to have_link '2'
  end

end