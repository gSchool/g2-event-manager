require 'spec_helper'

feature 'events management' do
  def log_in(user)
    visit new_login_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_on 'Submit'
    click_link 'Add Event'
  end

  describe "Guest access" do
    scenario 'Guests cannot create an event' do
      visit root_path
      click_on 'Add Event'
      expect(page).to have_content('You must login to create an event')
    end
  end

  describe "with a logged in user" do
    before do
      @user = User.create!(email: 'bob@bob.com', password: 'aB12341234', password_confirmation: 'aB12341234', email_confirmed: true, token: SecureRandom.uuid, calendar_token: SecureRandom.uuid)
      log_in(@user)
    end

    scenario "user can see a list of events on the index page" do
      visit '/'
      click_on 'Add Event'
      fill_in 'Name', with: 'Ignite Boulder'
      page.find('#event_date').set(1.days.from_now)
      fill_in 'Description', with: 'Awesomeness'
      fill_in 'Location', with: 'Boulder Theatre'
      fill_in 'Capacity', with: 500
      fill_in 'Category', with: 'Boulder Startup Week'
      click_on 'Create Event'
      visit ('/')
      expect(page).to have_content 'Ignite Boulder'

    end

    scenario "user can create and see the event they created" do
      visit '/'
      click_on 'Add Event'
      fill_in 'Name', with: 'Ignite Boulder'
      page.find('#event_date').set(1.days.from_now)
      fill_in 'Description', with: 'Awesomeness'
      fill_in 'Location', with: 'Boulder Theatre'
      fill_in 'Capacity', with: 500
      select('8am', :from => 'Start time')
      select('9am', :from => 'End time')
      fill_in 'Category', with: 'Boulder Startup Week'
      attach_file('Event pic', Rails.root.join('spec/images/image.png'))
      click_on 'Create Event'

      expect(page).to have_content 'Ignite Boulder'
      expect(page).to have_content 'Boulder Theatre'
      expect(page).to have_content 'Awesomeness'
      expect(page).to have_content 'Boulder Startup Week'
      expect(page).to have_content '500'
      expect(page).to have_content '8am'
      expect(page).to have_content '9am'
      expect(page).to have_content 'Edit this Event'
      expect(page).to have_css('img', visible: 'image.png')

      click_on 'My Events'
      expect(page).to have_content 'My events'
      expect(page).to have_content 'Ignite Boulder'
      expect(page).to have_content 'Boulder Theatre'

      click_on 'Ignite Boulder'
      expect(page).to have_content 'Ignite Boulder'
      expect(page).to have_content 'Boulder Theatre'
      expect(page).to have_content 'Awesomeness'
      expect(page).to have_content 'Boulder Startup Week'
      expect(page).to have_content '500'
      expect(page).to have_content '8am'
      expect(page).to have_content '9am'
    end

    scenario "user cannot submit an empty event form" do
      visit '/'
      click_on 'Add Event'
      click_on 'Create Event'

      expect(page).to have_content "Name can't be blank"
      expect(page).to have_content "Description can't be blank"
    end

    scenario 'a user can edit an event' do
      visit '/'
      click_on 'Add Event'
      fill_in 'Name', with: 'Ignite Boulder'
      page.find('#event_date').set(1.days.from_now)
      fill_in 'Description', with: 'Awesomeness'
      fill_in 'Location', with: 'Boulder Theatre'
      fill_in 'Capacity', with: 500
      select('8am', :from => 'Start time')
      select('9am', :from => 'End time')
      fill_in 'Category', with: 'Boulder Startup Week'
      attach_file('Event pic', Rails.root.join('spec/images/image.png'))
      click_on 'Create Event'

      click_on 'Edit this Event'

      fill_in 'Name', with: 'Ignite Boulder'
      page.find('#event_date').set(1.days.from_now)
      fill_in 'Description', with: 'Awesomeness'
      fill_in 'Location', with: 'Boulder Theatre'
      fill_in 'Capacity', with: 300
      select('9am', :from => 'Start time')
      select('10am', :from => 'End time')
      fill_in 'Category', with: 'Boulder Startup Week'
      attach_file('Event pic', Rails.root.join('spec/images/image.png'))
      click_on 'Update Event'

      expect(page).to have_content '10am'
      expect(page).to have_content '300'
    end

    scenario 'a user can register for an event' do
      Event.create!(
        name: "Ignite Boulder",
        location: "Boulder, CO",
        date: 1.days.from_now,
        description: "This is a description",
        capacity: 500,
        category: "test",
        start_time: "01:00",
        end_time: "02:00"
      )

      visit root_path
      click_on 'Ignite Boulder'
      click_on 'RSVP for this Event'
      expect(page).to have_content('Successfully registered')
      expect(page).to have_content('Tickets Remaining: 499')

      click_on 'Unregister for this Event'
      expect(page).to have_content('You are no longer registered for this event')
      expect(page).to have_content('Tickets Remaining: 500')
    end

    scenario 'a user can be waitlisted for a full event and un-waitlist' do
      event = Event.create!(
        name: "Ignite Boulder",
        location: "Boulder, CO",
        date: 1.days.from_now,
        description: "This is a description",
        capacity: 1,
        category: "test",
        start_time: "01:00",
        end_time: "02:00"
      )
      another_user = User.create!(email: 'sue@sue.com', password: 'aB12341234', password_confirmation: 'aB12341234')
      Registration.create!(event: event, user: another_user, role: :guest)

      visit root_path
      click_on 'Ignite Boulder'
      click_on 'Add me to Wait List'
      expect(page).to have_content 'You have been waitlisted'
      click_on 'Remove me from Wait List'
      expect(page).to have_link 'Add me to Wait List'
    end

    scenario 'only a user can view open spaces for an event' do
      Event.create!(
        name: "Ignite Boulder",
        location: "Boulder, CO",
        date: 1.days.from_now,
        description: "This is a description",
        capacity: 500,
        category: "test",
        start_time: "01:00",
        end_time: "02:00"
      )

      visit '/events'
      click_on 'Ignite Boulder'
      expect(page).to have_content 'Tickets Remaining: 500'
      click_on 'Logout'
      visit '/events'
      click_on 'Ignite Boulder'
      expect(page).to_not have_content 'Tickets Remaining: 500'
    end
  end
end