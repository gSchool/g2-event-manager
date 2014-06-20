require 'spec_helper'


feature 'personalized event calendar' do
  scenario 'users can add their events to their calendar software' do
    user_calendar_token = SecureRandom.uuid
    user = User.create!(email: 'user@example.com', password: 'Password1', email_confirmed: true, calendar_token: user_calendar_token)
    event = Event.create!(
      name: "#{Faker::Lorem.word.capitalize} Meetup",
      location: Faker::Address.city,
      date: rand(25).days.from_now,
      description: Faker::Company.catch_phrase,
      capacity: rand(30)+10,
      category: Faker::Commerce.department,
      start_time: "07:00",
      end_time: "08:00"
    )
    visit '/'
    user_login(user.email, user.password)

    click_link event.name

    click_on "RSVP for this Event"

    click_link "My Events"

    click_link user_calendar_token

    expect(current_path).to eq("/users/calendar/#{user_calendar_token}.ics")

    expect(page).to have_content(event.name)
  end

end