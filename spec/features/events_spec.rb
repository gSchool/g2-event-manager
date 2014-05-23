require 'spec_helper'

feature 'events managment' do

  def log_in_user(user)
    visit new_login_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Submit'
  end

  describe 'creating an event' do
    scenario "logged in user can create an event" do
      user = User.create!(email: 'bob@bob.com', password: 'password', password_confirmation: 'password')
      log_in_user(user)

      visit '/'
      click_on 'See All Events'
      click_on 'Add Event'
      fill_in 'Name', with: 'Ignite Boulder'
      page.find('#event_date').set(1.days.from_now)
      fill_in 'Description', with: 'Awesomeness'
      fill_in 'Location', with: 'Boulder Theatre'
      fill_in 'Capacity', with: 500
      fill_in 'Category', with: 'Boulder Startup Week'
      click_on 'Create Event'

      # they end up on the show page for the event
      within('.event') do
        expect(page).to have_content 'Ignite Boulder'
        expect(page).to have_content 'Boulder Theatre'
        expect(page).to have_content 'Awesomeness'
        expect(page).to have_content 'Boulder Startup Week'
        expect(page).to have_content '500'
        expect(page).to have_content "Edit this Event"
      end

      # make sure it shows up on my page
      visit user_path(user)
      within('#my_events') do
        expect(page).to have_content 'My events'
        expect(page).to have_content 'Ignite Boulder'
        expect(page).to have_content 'Boulder Theatre'
      end
    end

    scenario 'Guests cannot create an event' do
      visit '/'
      click_on 'See All Events'
      click_on 'Add Event'
      expect(page).to have_content('You must login to create an event')
    end
  end

  scenario 'a user can register and unregister for an event' do
    user = User.create!(email: 's@s.com', password: 'password', password_confirmation: 'password')

    event = Event.create!(
      name: "Ignite Boulder",
      location: "Boulder Theatre",
      date: 1.days.from_now,
      description: "Awesomeness",
      capacity: 500,
      category: "Boulder Startup Week",
      user: user
    )

    another_user = User.create!(email: 'test@s.com', password: 'password', password_confirmation: 'password')

    log_in_user(another_user)

    click_on 'See All Events'
    click_on 'Ignite Boulder'
    click_on 'RSVP for this Event'
    expect(page).to have_content('Successfully registered')
    expect(page).to have_content('Tickets Remaining: 499')

    visit user_path(another_user)

    within('#attending') do
      expect(page).to have_content('Ignite Boulder')
    end
  end

  scenario 'a user can be waitlisted and un-waitlist for a full event ' do
    user = User.create!(email: 'bob@bob.com', password: '12341234', password_confirmation: '12341234')

    event = Event.create!(
      name: "Test Meetup",
      location: "Boulder, CO",
      date: 1.days.from_now,
      description: "This is a description",
      capacity: 1,
      category: "test",
      user: user
    )

    Registration.create!(event: event, user: user, role: :guest)

    another_user = User.create!(email: 'test1@s.com', password: 'password', password_confirmation: 'password')

    log_in_user(another_user)

    click_on 'See All Events'
    click_on 'Test Meetup'
    click_on 'Add me to Wait List'
    expect(page).to have_content 'You have been waitlisted'

    visit user_path(another_user)
    within('#waitlisted') do
      expect(page).to have_content 'Test Meetup'
    end

    visit event_path(event)
    click_on 'Remove me from Wait List'
    expect(page).to have_link 'Add me to Wait List'
    visit user_path(another_user)
    within('#waitlisted') do
      expect(page).to have_no_content 'Test Meetup'
    end
  end

  scenario 'only a logged in user can view open spaces for an event' do
    user = User.create!(email: 's@s.com', password: 'password', password_confirmation: 'password')

    Event.create!(
      name: "Ignite Boulder",
      location: "Boulder Theatre",
      date: 1.days.from_now,
      description: "Awesomeness",
      capacity: 500,
      category: "Boulder Startup Week",
      user: user
    )

    log_in_user(user)

    visit '/events'
    click_on 'Ignite Boulder'
    expect(page).to have_content 'Tickets Remaining: 500'
    click_on 'Logout'
    visit '/events'
    click_on 'Ignite Boulder'
    expect(page).to_not have_content 'Tickets Remaining: 500'
  end
end